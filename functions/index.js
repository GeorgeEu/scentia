const functions = require("firebase-functions");
const admin = require("firebase-admin");

// Initialize Firebase Admin SDK
admin.initializeApp();

// Import functions from the accounting directory
const getLogs = require("./accounting/getLogs");

// Export the functions
exports.getLogs = functions.https.onRequest(getLogs);
