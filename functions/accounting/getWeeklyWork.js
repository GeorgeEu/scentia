const admin = require("firebase-admin");

const getWeeklyWork = async (context) => {
  try {
    const db = admin.firestore();

    // Define the stored data and pricing for Firestore and Cloud Storage
    const firestoreDataInMB = 0.13; // Amount of Firestore data in MB
    const firestoreCostPerMB = 0.00036; // Firestore cost per MB in dollars
    const cloudStorageDataInMB = 1.37; // Cloud storage data in MB
    const cloudStorageCostPerMB = 0.000052; // Cloud storage cost per MB in dollars
    const invokeCost = 0.00000086; // Additional cost to be divided among users

    // Calculate the total storage costs
    const firestoreStorageCost = firestoreDataInMB * firestoreCostPerMB;
    const cloudStorageCost = cloudStorageDataInMB * cloudStorageCostPerMB;
    const totalCost = firestoreStorageCost + cloudStorageCost + invokeCost;

    console.log(`Firestore data: ${firestoreDataInMB} MB, Cost: $${firestoreStorageCost}`);
    console.log(`Cloud Storage data: ${cloudStorageDataInMB} MB, Cost: $${cloudStorageCost}`);
    console.log(`Additional service cost: $${invokeCost}`);
    console.log(`Total cost: $${totalCost}`);

    let lastUserDoc = null; // Keep track of the last document for pagination
    const batchSize = 500; // Number of users (documents) to fetch in each iteration
    let totalProcessedUsers = 0; // Total users processed

    do {
      // Fetch a batch of users (documents)
      let query = db.collection("scentia").orderBy("__name__").limit(batchSize);
      if (lastUserDoc) {
        query = query.startAfter(lastUserDoc);
      }
      const snapshot = await query.get();

      if (snapshot.size === 0) {
        break;
      }

      totalProcessedUsers += snapshot.size;

      // Iterate over each user document
      for (const userDoc of snapshot.docs) {
        const userId = userDoc.id;
        const currentBalance = userDoc.data().balance || 0;
        const costPerUser = totalCost / snapshot.size; // Divide the total cost evenly among users

        // Perform a transaction for each user to update the balance
        await db.runTransaction(async (transaction) => {
          const userDocRef = db.collection("scentia").doc(userId);

          // Get the current balance inside the transaction to ensure consistency
          const userDocSnapshot = await transaction.get(userDocRef);
          if (!userDocSnapshot.exists) {
            console.log(`User with ID ${userId} does not exist.`);
            return;
          }

          const currentBalanceInTransaction = currentBalance;
          const updatedBalance = currentBalanceInTransaction - costPerUser;

          // Update the balance in the transaction
          transaction.update(userDocRef, {balance: updatedBalance});
        });

        console.log(`Updated balance for user ID: ${userId}`);
      }

      // Set the last document (for pagination)
      lastUserDoc = snapshot.docs[snapshot.docs.length - 1];

      console.log(`Processed ${totalProcessedUsers} users so far...`);
    } while (lastUserDoc); // Continue paginating until all users are processed

    console.log(`Successfully updated balances for ${totalProcessedUsers} users.`);

    return null;
  } catch (error) {
    console.error("Error processing balances:", error);
  }
};

module.exports = getWeeklyWork;
