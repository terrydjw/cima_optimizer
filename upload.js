const admin = require('firebase-admin');
const fs = require('fs');
const yargs = require('yargs/yargs');
const { hideBin } = require('yargs/helpers');

// --- Firebase Initialization ---
const serviceAccount = require('./serviceAccountKey.json');
admin.initializeApp({
    credential: admin.credential.cert(serviceAccount)
});
const db = admin.firestore();

/**
 * Uploads an array of JSON objects from a file to a specified Firestore sub-collection.
 * @param {string} moduleId - The ID of the module document (e.g., 'BA4').
 * @param {string} collectionName - The name of the sub-collection ('lessons' or 'questions').
 * @param {string} filePath - The path to the JSON file to upload.
 */
const uploadJsonToFirestore = async (moduleId, collectionName, filePath) => {
    try {
        console.log(`Reading ${filePath}...`);
        const fileContent = fs.readFileSync(filePath, 'utf8');
        const data = JSON.parse(fileContent);

        const collectionRef = db.collection('modules').doc(moduleId).collection(collectionName);

        console.log(`Starting upload to "modules/${moduleId}/${collectionName}"...`);
        for (const item of data) {
            if (item.id) {
                await collectionRef.doc(item.id).set(item);
            }
        }
        console.log(`✅ Successfully uploaded ${data.length} documents to "${collectionName}".`);
    } catch (error) {
        console.error(`❌ Error uploading ${collectionName}:`, error);
    }
};

const main = async () => {
    // --- Argument Parsing ---
    const argv = yargs(hideBin(process.argv))
        .option('module', {
            alias: 'm',
            description: 'The ID of the module (e.g., BA1, P1)',
            type: 'string',
            demandOption: true
        })
        // Add the new required title option
        .option('title', {
            alias: 't',
            description: 'The display title of the module',
            type: 'string',
            demandOption: true
        })
        .option('lessons', {
            alias: 'l',
            description: 'Path to the lessons JSON file',
            type: 'string',
            demandOption: true
        })
        .option('questions', {
            alias: 'q',
            description: 'Path to the questions JSON file',
            type: 'string',
            demandOption: true
        })
        .help()
        .alias('help', 'h')
        .argv;

    console.log('--- Starting Data Upload ---');

    // --- SOLUTION IMPLEMENTATION ---
    // This new block creates or updates the parent document with a title.
    // This makes it "real" and discoverable by your app's query.
    try {
        const moduleRef = db.collection('modules').doc(argv.module);
        await moduleRef.set({ title: argv.title }, { merge: true });
        console.log(`✅ Materialized parent document for module "${argv.module}" with title.`);
    } catch (error) {
        console.error(`❌ Error setting module title:`, error);
        return;
    }
    // --- END OF SOLUTION ---

    await uploadJsonToFirestore(argv.module, 'lessons', argv.lessons);
    await uploadJsonToFirestore(argv.module, 'questions', argv.questions);

    console.log('\n--- All uploads complete. ---');
};

main().catch(console.error);
