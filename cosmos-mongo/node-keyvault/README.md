# Azure Cosmos DB Mongo API example with Node.js

## Prerequisites

- An Azure account with an active subscription. Create an account for free.
- Node.js LTS.
- Optional: Terraform

## Create Azure Cosmos DB

Either use the Azure portal to create the Cosmos account configured to use Azure Cosmos DB's API for MongoDB  or use the provided terraform script and export the environment variables or place inside an `src/.env` file.

```
terraform init
terraform apply
```

## Prepare the working environment

First, set up some environment variables by using the following commands:

```
AZ_KEY_VAULT_NAME=<YOUR_KEY_VAULT_NAME>
AZ_SECRET_NAME=<YOUR_KEY_VAULT_SECRET_NAME>
```

Replace the placeholders with the following values:

- `<YOUR_KEY_VAULT_NAME>`: The name for your key vault.
- `<YOUR_KEY_VAULT_SECRET_NAME>`: The name for your key vault secret.

## Install Node.js dependencies

Install the node dependencies in the `src/` directory via: 

```
npm install
```

## Additional Documentation

- [Build an app using Node.js and Azure Cosmos DB's API for MongoDB](https://docs.microsoft.com/en-us/azure/cosmos-db/mongodb/nodejs-console-app)
- [Secure Azure Cosmos credentials using Azure Key Vault](https://docs.microsoft.com/en-us/azure/cosmos-db/access-secrets-from-keyvault)
