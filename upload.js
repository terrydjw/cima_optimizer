const admin = require('firebase-admin');
const fs = require('fs');

const serviceAccount = require('./serviceAccountKey.json');

admin.initializeApp({
    credential: admin.credential.cert(serviceAccount)
});

const db = admin.firestore();

const uploadJsonToFirestore = async (filePath, collectionName) => {
    try {
        console.log(`Reading ${filePath}...`);
        const fileContent = fs.readFileSync(filePath, 'utf8');
        const data = JSON.parse(fileContent);

        console.log(`Starting upload to "${collectionName}" collection...`);
        for (const item of data) {
            // I'm now using the 'id' from my JSON as the document ID.
            // .set() will create the document if it doesn't exist, or overwrite it if it does.
            if (item.id) {
                await db.collection(collectionName).doc(item.id).set(item);
            }
        }
        console.log(`Successfully uploaded/updated ${data.length} documents in "${collectionName}".`);
    } catch (error) {
        console.error(`Error uploading ${collectionName}:`, error);
    }
};

const runUploads = async () => {
    // It's a good idea to clear the collections first to remove old documents.
    // This part is manual: go to Firebase Console and delete the collections.
    console.log('Please ensure you have cleared the old collections in the Firebase Console first.');

    await uploadJsonToFirestore('./assets/lessons.json', 'lessons');
    await uploadJsonToFirestore('./assets/questions.json', 'questions');
    console.log('--- All uploads complete. ---');
    process.exit(0);
};

runUploads();