const admin = require("firebase-admin");

const getWeeklyWork = async (context) => {
  try {
    const db = admin.firestore();
    const collections = await db.listCollections();
    let totalSizeInBytes = 0;

    for (const collection of collections) {
      let collectionSizeInBytes = 0;
      const snapshot = await collection.get();

      for (const doc of snapshot.docs) {
        const data = doc.data();
        let docSizeInBytes = 0;

        // Document metadata (Firestore uses around 32 bytes of metadata per document)
        const docIdSize = Buffer.byteLength(doc.id, "utf8");
        const metadataSize = 32; // Overhead for metadata (creation time, update time, etc.)
        docSizeInBytes += docIdSize + metadataSize;

        for (const [key, value] of Object.entries(data)) {
          const keySize = Buffer.byteLength(key, "utf8");
          let valueSize = 0;

          switch (typeof value) {
            case "string":
              valueSize = Buffer.byteLength(value, "utf8");
              break;
            case "number":
              valueSize = Buffer.byteLength(value.toString(), "utf8");
              break;
            case "boolean":
              valueSize = Buffer.byteLength(value.toString(), "utf8");
              break;
            case "object":
              if (value instanceof admin.firestore.Timestamp) {
                valueSize = 8;
              } else if (Array.isArray(value)) {
                valueSize = Buffer.byteLength(JSON.stringify(value), "utf8");
              } else if (value !== null) {
                valueSize = Buffer.byteLength(JSON.stringify(value), "utf8");
              }
              break;
            default:
              console.warn(`Unhandled data type for key "${key}": ${typeof value}`);
          }

          docSizeInBytes += keySize + valueSize;
        }

        collectionSizeInBytes += docSizeInBytes;
      }

      const collectionSizeInMB = collectionSizeInBytes / (1024 * 1024);
      totalSizeInBytes += collectionSizeInBytes;

      // Log the full collection size without rounding
      console.log(`Collection ${collection.id} size: ${collectionSizeInMB} MB`);
    }

    const totalSizeInMB = totalSizeInBytes / (1024 * 1024);
    console.log(`Total Firestore size: ${totalSizeInMB} MB`);

    return null;
  } catch (error) {
    console.error("Error calculating Firestore size:", error);
  }
};

module.exports = getWeeklyWork;
