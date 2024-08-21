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

    // Get the school document using the schoolId
    const schoolDoc = await admin.firestore().
        collection("schools").doc(schoolId).get();

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
    const ownerBalanceDoc = await admin.firestore().
        collection("scentia").doc(ownerId).get();

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
    const pricingDoc = await admin.firestore().
        collection("accounting").doc("pricing").get();

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
    const userLogsDoc = await admin.firestore().
        collection("logs").doc(userId).get();

    // Combine checks for existence, data presence, and non-empty logs map
    if (!userLogsDoc.exists ||
    !userLogsDoc.data() ||
    Object.keys(userLogsDoc.data()).length === 0) {
      console.log("No logs found or logs map is empty for user");
      return {message: "No logs found or logs map is empty for the current user."};
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

    // Subtract the total cost from the owner's balance and update it
    const newBalance = balance - totalCost;
    await admin.firestore().
        collection("scentia").doc(ownerId).update({balance: newBalance});

    console.log(`Owner's new balance: ${newBalance}`);

    // Delete the logs after processing
    await admin.firestore().collection("logs").doc(userId).delete();

    console.log(`Logs deleted for user ID: ${userId}`);

    return {message: "Logs processed, balance updated and logs deleted"};
  } catch (error) {
    console.error("Error processing logs:", error);
    throw new functions.https.HttpsError(
        "internal",
        "An error occurred while processing logs.",
    );
  }
});
