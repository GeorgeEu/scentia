const admin = require("firebase-admin");

module.exports = async (request, response) => {
  const idToken = request.body.token;
  const schoolId = request.body.schoolId; // Accept the schoolId from the request body

  try {
    // Verify the ID token and decode it to get the UID
    if (!idToken) {
      throw new Error("ID token is missing");
    }

    const decodedToken = await admin.auth().verifyIdToken(idToken);
    const uid = decodedToken.uid;

    // Log the UID and schoolId
    console.log(`Decoded UID: ${uid}`);
    console.log(`School ID: ${schoolId}`);

    if (!schoolId) {
      throw new Error("School ID is missing");
    }

    // Start a Firestore transaction
    const result = await admin.firestore().runTransaction(async (transaction) => {
      // Reference to the pricing document
      const pricingRef = admin.firestore().
          collection("accounting").doc("pricing");

      // Fetch the pricing document within the transaction
      const pricingDoc = await transaction.get(pricingRef);

      if (!pricingDoc.exists) {
        throw new Error("Pricing document does not exist");
      }

      const schoolDocRef = admin.firestore().collection("schools").doc(schoolId);
      const schoolDoc = await transaction.get(schoolDocRef);

      if (!schoolDoc.exists) {
        throw new Error(`School document for ID ${schoolId} does not exist`);
      }

      const schoolData = schoolDoc.data();
      if (!schoolData || !schoolData.owner) {
        throw new Error(`Owner reference is missing in the school document`);
      }

      const ownerRef = schoolData.owner; // Assuming 'owner' is a DocumentReference
      const ownerId = ownerRef.id;

      console.log("School Owner ID:", ownerId);

      // Get the owner's balance from the 'scentia' collection
      const ownerBalanceDocRef = admin.firestore().
          collection("scentia").doc(ownerId);
      const ownerBalanceDoc = await transaction.get(ownerBalanceDocRef);

      if (!ownerBalanceDoc.exists) {
        throw new Error(`Owner balance document for ID ${ownerId} error`);
      }

      const ownerBalanceData = ownerBalanceDoc.data();
      if (!ownerBalanceData || ownerBalanceData.balance === undefined) {
        throw new Error(`Balance is owner ID error`);
      }

      const balance = ownerBalanceData.balance;

      // Extract the pricing data
      const pricingData = pricingDoc.data();
      const dbDeletePrice = pricingData.dbDelete;
      const dbReadPrice = pricingData.dbRead;
      const dbWritePrice = pricingData.dbWrite;

      // Log the pricing information
      console.log("Owner's Current Balance:", balance);
      console.log("Pricing Information:");
      console.log(`dbDelete: ${dbDeletePrice}`);
      console.log(`dbRead: ${dbReadPrice}`);
      console.log(`dbWrite: ${dbWritePrice}`);

      // Retrieve user logs
      const userLogsDocRef = admin.firestore().
          collection("logs").doc(uid);
      const userLogsDoc = await transaction.get(userLogsDocRef);

      // Combine checks for existence, data presence, and non-empty logs map
      if (!userLogsDoc.exists ||
            !userLogsDoc.data() ||
            Object.keys(userLogsDoc.data()).length === 0) {
        console.log(`No logs found or logs map is empty for user ${uid}`);
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
        const cost = (dbDelete * dbDeletePrice) + (dbRead * dbReadPrice) + (dbWrite * dbWritePrice);
        totalCost += cost;
      });

      console.log(`Total cost for user ${uid}: ${totalCost}`);

      // Additional costs
      const invokeCost = 0.00000086;
      const callTimeCost = 0.00003;
      const additionalCosts = invokeCost + callTimeCost;

      // Subtract the total cost of logs and additional costs from the owner's balance
      const newBalance = balance -
            totalCost -
            additionalCosts;
      transaction.update(ownerBalanceDocRef, {balance: newBalance});

      console.log(`Owner's new balance after additional costs: ${newBalance}`);

      // Delete the logs after processing
      transaction.delete(userLogsDocRef);

      console.log(`Logs deleted for user ID: ${uid}`);

      // Return the pricing data and total cost from the transaction
      return {dbDelete: dbDeletePrice,
        dbRead: dbReadPrice,
        dbWrite: dbWritePrice,
        totalCost, newBalance};
    });

    // Use the result from the transaction to construct the response
    const logs = `Logs for school ${schoolId} and user ${uid}.
        Pricing - dbDelete: ${result.dbDelete},
        dbRead: ${result.dbRead},
        dbWrite: ${result.dbWrite},
        Total Cost: ${result.totalCost},
        Owner's New Balance: ${result.newBalance}`;

    // Log final success message
    console.log("Logs processed, balance updated, and logs deleted successfully.");

    // Send the logs back as a response
    response.status(200).send({logs: logs});
  } catch (error) {
    console.error("Error verifying ID token or processing request:", error.message);
    response.status(400).send("Invalid ID token or request: " + error.message);
  }
};
