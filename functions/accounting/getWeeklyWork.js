const admin = require("firebase-admin");

const getWeeklyWork = async (context) => {
  try {
    const db = admin.firestore();

    // Define the stored data and pricing
    const storedDataInMB = 0.13; // Predefined stored amount in MB
    const costPerMB = 0.00036; // Pricing per MB in dollars

    // Calculate the total storage cost
    const storageCost = storedDataInMB * costPerMB;
    console.log(`Stored data: ${storedDataInMB} MB`);
    console.log(`Storage cost: $${storageCost}`);

    let lastDoc = null; // Keep track of the last document for pagination
    const batchSize = 500; // Number of documents to fetch in each iteration
    let processedUsers = 0;

    do {
      // Fetch a batch of users (documents)
      let query = db.collection("scentia").orderBy("__name__").limit(batchSize);
      if (lastDoc) {
        query = query.startAfter(lastDoc);
      }
      const snapshot = await query.get();

      if (snapshot.size === 0) {
        break;
      }

      processedUsers += snapshot.size;

      // Iterate over each user document
      for (const doc of snapshot.docs) {
        const userId = doc.id;
        const currentBalance = doc.data().balance || 0;
        const costPerUser = storageCost / snapshot.size; // Divide the cost evenly among users

        // Perform a transaction for each user to update the balance
        await db.runTransaction(async (transaction) => {
          const userDocRef = db.collection("scentia").doc(userId);

          // Get the current balance inside the transaction to ensure consistency
          const userDoc = await transaction.get(userDocRef);
          if (!userDoc.exists) {
            console.log(`User with ID ${userId} does not exist.`);
            return;
          }

          const currentBalanceInTransaction = currentBalance;
          const newBalance = currentBalanceInTransaction - costPerUser;

          // Update the balance in the transaction
          transaction.update(userDocRef, {balance: newBalance});
        });

        console.log(`Updated balance for user ID: ${userId}`);
      }

      // Set the last document (for pagination)
      lastDoc = snapshot.docs[snapshot.docs.length - 1];

      console.log(`Processed ${processedUsers} users so far...`);
    } while (lastDoc); // Continue paginating until all users are processed

    console.log(`Successfully updated balances for ${processedUsers} users.`);

    return null;
  } catch (error) {
    console.error("Error processing balances:", error);
  }
};

module.exports = getWeeklyWork;
