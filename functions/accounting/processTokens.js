const admin = require("firebase-admin");

module.exports = async (req, res) => {
  try {
    // Get the ID token and tokens from the request body
    const idToken = req.body.token;
    const tokens = req.body.tokens;

    // Verify the ID token and get the user ID
    const decodedToken = await admin.auth().verifyIdToken(idToken);
    const uid = decodedToken.uid;

    // Validate that 'tokens' is a positive number
    if (typeof tokens !== "number" || tokens <= 0) {
      return res.status(400).send({error: "'tokens' must be a positive number"});
    }

    // Convert tokens to be added to balance (assuming tokens are in cents, divide by 1000)
    const convertedTokens = tokens / 1000;

    // Reference to the user's document in the 'scentia' collection
    const userRef = admin.firestore().collection("scentia").doc(uid);

    // Fetch the user's current 'balance' field
    const userDoc = await userRef.get();
    const currentBalance = userDoc.exists ? userDoc.data().balance || 0 : 0;
    const newBalance = currentBalance + convertedTokens;

    // Update or set the user's balance in the 'scentia' collection
    await userRef.set({balance: newBalance}, {merge: true});

    // Reference to the user's 'transactions' document in the 'transactions' collection
    const transactionRef = admin.firestore().collection("transactions").doc(uid);

    // Create a new transaction entry
    const transactionEntry = {
      time: Date.now(),
      firestore: tokens,
    };

    // Update or create the 'transactionsList' array
    await transactionRef.set(
        {
          transactionsList: admin.firestore.FieldValue.arrayUnion(transactionEntry),
        },
        {merge: true},
    );

    // Respond with a success message and the new balance
    return res.status(200).send({
      message: "Tokens processed successfully and transaction recorded",
      newBalance: newBalance,
    });
  } catch (error) {
    console.error("Error processing tokens:", error);
    return res.status(500).send({error: "Internal Server Error"});
  }
};
