const functions = require("firebase-functions");
const admin = require("firebase-admin");

// Initialize Firebase Admin SDK
admin.initializeApp();

// Import functions from the accounting directory
const getLogs = require("./accounting/getLogs");
const getWeeklyWork = require("./accounting/getWeeklyWork");

// Export the functions
exports.getLogs = functions.https.onRequest(getLogs);

// Schedule the getWeeklyWork function to run every week
exports.getWeeklyWork = functions.pubsub
    .schedule("every 24 hours")
    .onRun(getWeeklyWork);
