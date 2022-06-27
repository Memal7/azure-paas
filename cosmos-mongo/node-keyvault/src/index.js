const { MongoClient } = require('mongodb');
const { SecretClient } = require("@azure/keyvault-secrets");
const { DefaultAzureCredential } = require("@azure/identity");

// Load the .env file if exists
require('dotenv').config();

const keyVaultName = process.env.AZ_KEY_VAULT_NAME;
if (!keyVaultName) {
  throw Errro('Azure Key Vault name not found');
}
const secretName = process.env.AZ_SECRET_NAME;
if (!secretName) {
  throw Error('Azure Key Vault secret name not found');
}

async function run() {
  const credential = new DefaultAzureCredential();

  const url = "https://" + keyVaultName + ".vault.azure.net";
  const secretClient = new SecretClient(url, credential);
  const secret = await secretClient.getSecret(secretName);

  const mongoClient = new MongoClient(secret.value);
  try {
    await mongoClient.connect();
    const db = mongoClient.db('airbnb');
    const listingsAndReviews = db.collection('listingsAndReviews');
    await insertListings(listingsAndReviews);
    await findListings(listingsAndReviews, 5);
    await deleteListing(listingsAndReviews);
  } catch (error) {
    console.log(error);
  } finally {
    await mongoClient.close()
  }
}

async function insertListings(collection) {
  const docs = [
    { name: 'Ribeira Charming Duplex', bedrooms: 3, bathrooms: 1.0, last_review: '10-01-2022' },
    { name: 'Horto flat with small garden', bedrooms: 1, bathrooms: 1.0, last_review: '29-01-2022' },
    {
      name: 'Ocean View Waikiki Marina w/ parking', bedrooms: 3, bathrooms: 1.0, last_review: '13-01-2022'
    },
    { name: 'Private Room in Bushwick', bedrooms: 3, bathrooms: 1.5, last_review: '05-05-2022' },
    { name: 'Apt Linda Vista Lagoa - Rio', bedrooms: 3, bathrooms: 2.0, last_review: '01-04-2022' },
    { name: 'Container Tiny House w/ garden', bedrooms: 1, bathrooms: 1.0, last_review: '01-05-2022' }
  ];
  const options = { ordered: true };
  const result = await collection.insertMany(docs, options);
  console.log(`${result.insertedCount} documents were inserted`);
}

async function findListings(collection, resultsLimit) {
  const cursor = collection
    .find()
    .limit(resultsLimit);

  const results = await cursor.toArray();
  if (results.length > 0) {
    console.log(`Found ${results.length} listing(s):`);
    results.forEach((result, i) => {
      date = new Date(result.last_review).toDateString();

      console.log();
      console.log(`${i + 1}. name: ${result.name}`);
      console.log(`   _id: ${result._id}`);
      console.log(`   bedrooms: ${result.bedrooms}`);
      console.log(`   bathrooms: ${result.bathrooms}`);
      console.log(
        `   most recent review date: ${new Date(
          result.last_review
        ).toDateString()}`
      );
    });
  }
}

async function deleteListing(collection) {
  const query = { name: { $regex: 'garden' } };
  const result = await collection.deleteMany(query);
  console.log('Deleted ' + result.deletedCount + ' documents');
}

run().catch(console.dir);
