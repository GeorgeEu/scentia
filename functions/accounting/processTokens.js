const admin = require("firebase-admin");

module.exports = async (req, res) => {
  try {
    // Get the ID token from the request body
    const idToken = req.body.token;

    // Verify the ID token and get user information
    const decodedToken = await admin.auth().verifyIdToken(idToken);
    const uid = decodedToken.uid;

    // Get the 'tokens' from the request body
    const tokens = req.body.tokens;

    // Validate that 'tokens' is a number
    if (typeof tokens !== "number") {
      return res.status(400).send({error: "'tokens' must be a number"});
    }

    const convertedTokens = tokens/1000;
    // Reference to the user's document in the 'scentia' collection
    const userRef = admin.firestore().
        collection("scentia").doc(uid);

    // Fetch the user's current 'balance' field
    const userDoc = await userRef.get();

    if (userDoc.exists) {
      // Get the current balance
      const data = userDoc.data();
      const currentBalance = data.balance || 0;

      // Add the tokens to the current balance
      const newBalance = currentBalance + convertedTokens;

      // Update the 'balance' field
      await userRef.update({balance: newBalance});

      // Respond with a success message and the new balance
      return res.status(200).send({
        message: "Tokens processed successfully",
        newBalance: newBalance,
      });
    } else {
      // If the user document does not exist, create it with initial balance
      await userRef.set({balance: convertedTokens});

      // Respond with a success message and the new balance
      return res.status(200).send({
        message: "User document created and tokens added",
        newBalance: convertedTokens,
      });
    }
  } catch (error) {
    console.error("Error processing tokens:", error);
    return res.status(500).send({error: "Internal Server Error"});
  }
};
