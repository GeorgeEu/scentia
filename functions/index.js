const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();

exports.processLogsAndUpdateBalance = functions.https.onCall(async (data, context) => {
  const idToken = data.token;
  const schoolId = data.schoolId;

  if (!idToken || !schoolId) {
    throw new functions.https.HttpsError(
        "invalid-argument",
        "The function must be called with an ID token and a school ID.",
    );
  }

  try {
    // Verify the ID token
    const decodedToken = await admin.auth().verifyIdToken(idToken);
    const userId = decodedToken.uid;

    console.log("Decoded User ID:", userId);
    console.log("School ID:", schoolId);

    // Start a Firestore transaction
    await admin.firestore().runTransaction(async (transaction) => {
      // Get the school document using the schoolId
      const schoolDocRef = admin.firestore().
          collection("schools").doc(schoolId);
      const schoolDoc = await transaction.get(schoolDocRef);

      if (!schoolDoc.exists) {
        console.log("School document not found.");
        throw new functions.https.HttpsError(
            "not-found",
            "School information not found.",
        );
      }

      const schoolData = schoolDoc.data();
      const ownerRef = schoolData.owner; // Assuming 'owner' is a DocumentReference
      const ownerId = ownerRef.id;

      console.log("School Owner ID:", ownerId);

      // Get the owner's balance from the 'scentia' collection
      const ownerBalanceDocRef = admin.firestore().
          collection("scentia").doc(ownerId);
      const ownerBalanceDoc = await transaction.get(ownerBalanceDocRef);

      if (!ownerBalanceDoc.exists) {
        console.log("Owner balance document not found.");
        throw new functions.https.HttpsError(
            "not-found",
            "Owner balance information not found.",
        );
      }

      const balance = ownerBalanceDoc.data().balance || 0;
      console.log("Owner's Current Balance:", balance);

      // Fetch pricing information from the accounting collection
      const pricingDocRef = admin.firestore().
          collection("accounting").doc("pricing");
      const pricingDoc = await transaction.get(pricingDocRef);

      if (!pricingDoc.exists) {
        console.log("Pricing document not found.");
        throw new functions.https.HttpsError(
            "not-found",
            "Pricing information not found.",
        );
      }

      const pricingData = pricingDoc.data();
      const dbDeletePrice = pricingData.dbDelete || 0;
      const dbReadPrice = pricingData.dbRead || 0;
      const dbWritePrice = pricingData.dbWrite || 0;

      // Fetch logs for the current user from Firestore
      const userLogsDocRef = admin.firestore().
          collection("logs").doc(userId);
      const userLogsDoc = await transaction.get(userLogsDocRef);

      // Combine checks for existence, data presence, and non-empty logs map
      if (!userLogsDoc.exists ||
      !userLogsDoc.data() ||
      Object.keys(userLogsDoc.data()).length === 0) {
        console.log(`No logs found or logs map is empty for user`);
        return {message: "No logs found or logs map is empty for user."};
      }

      const logsData = userLogsDoc.data();
      let totalCost = 0;

      // Process each entry in the logs map, where each key is a timestamp
      Object.entries(logsData).forEach(([timestamp, log]) => {
        const dbDelete = log.dbDelete || 0;
        const dbRead = log.dbReads || 0;
        const dbWrite = log.dbWrites || 0;

        console.log(`Timestamp: ${timestamp},
        dbDelete: ${dbDelete},
        dbRead: ${dbRead},
        dbWrite: ${dbWrite}`);

        // Calculate the cost for this log entry
        const cost = (dbDelete * dbDeletePrice) +
        (dbRead * dbReadPrice) +
        (dbWrite * dbWritePrice);
        totalCost += cost;
      });

      console.log("**********************************");
      console.log(`Total cost for user ID: ${userId} is ${totalCost}`);

      // Additional costs
      const invokeCost = 0.00000086;
      const callTimeCost = 0.00003;
      const additionalCosts = invokeCost + callTimeCost;

      // Subtract the total cost of logs and additional costs from the owner's balance
      const newBalance = balance - totalCost - additionalCosts;
      transaction.update(ownerBalanceDocRef, {balance: newBalance});

      console.log(`Owner's new balance after additional costs: ${newBalance}`);

      // Delete the logs after processing
      transaction.delete(userLogsDocRef);

      console.log(`Logs deleted for user ID: ${userId}`);
    });

    return {message: "Logs processed, balance updated, and logs deleted successfully."};
  } catch (error) {
    console.error("Error processing logs:", error);
    throw new functions.https.HttpsError(
        "internal",
        "An error occurred while processing logs.",
    );
  }
});
