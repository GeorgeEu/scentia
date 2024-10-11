const admin = require("firebase-admin");

// Cloud function to create or check user and school documents
// Cloud function to create or check user and school documents
module.exports = async (req, res) => {
  try {
    // Decode the user token and extract user information
    const idToken = req.body.token;
    const schoolName = req.body.schoolName;
    const decodedToken = await admin.auth().verifyIdToken(idToken);
    const userId = decodedToken.uid;
    const user = await admin.auth().getUser(userId);

    const userName = user.displayName ? user.displayName : user.email;

    const db = admin.firestore();
    const scentiaCollection = db.collection("scentia");
    const schoolsCollection = db.collection("schools");
    const usersCollection = db.collection("users");

    // Step 1: Check and create document in 'scentia' collection
    const scentiaDoc = await scentiaCollection.doc(userId).get();
    if (!scentiaDoc.exists) {
      await scentiaCollection.doc(userId).set({
        balance: 0,
        name: userName,
      });
    }

    // Step 2: Create path for 'scentia/currentUserId'
    const schoolOwnerPath = scentiaCollection.doc(userId).path;

    // Step 3: Check and create document in 'schools' collection
    let newSchoolDocRef = null;
    const schoolsSnapshot = await schoolsCollection
        .where("owner", "==", db.doc(schoolOwnerPath))
        .get();

    if (schoolsSnapshot.empty) {
      newSchoolDocRef = schoolsCollection.doc();
      await newSchoolDocRef.set({
        owner: db.doc(schoolOwnerPath),
        name: schoolName,
      });
    } else {
      newSchoolDocRef = schoolsSnapshot.docs[0].ref; // Reference to the existing document
    }

    // Step 4: Check and create document in 'users' collection
    const userDoc = await usersCollection.doc(userId).get();
    if (!userDoc.exists) {
      await usersCollection.doc(userId).set({
        class: null,
        name: userName,
      });
    }

    // Step 5: Create sub-collection 'account' inside 'users/{userId}'
    const accountDocRef = usersCollection.doc(userId)
        .collection("account").doc("permission");
    await accountDocRef.set({
      status: "owner", // Set the status to 'owner'
      school: newSchoolDocRef, // Store the reference to the school document
    });

    return res.status(200).send({message: "successfully."});
  } catch (error) {
    console.error("Error in createInstitution:", error);
    return res.status(500).send({error: "Internal Server Error"});
  }
};

