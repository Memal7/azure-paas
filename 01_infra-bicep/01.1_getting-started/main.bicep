// Define parameters
param storageAccountName string = 'stgaccbicep${uniqueString(resourceGroup().id)}'
param appServiceAppName string = 'appServiceBicep${uniqueString(resourceGroup().id)}'
param location string = 'North Europe'

// In terminal you will asked, if the environment is prod or nonprod.
@allowed([
  'nonprod'
  'prod'
])
param environmentType string

// Define the variables
var storageAccountSkuName = (environmentType == 'prod') ? 'Standard_GRS' : 'Standard_LRS'


// Create a Storage Account
resource storageAccount 'Microsoft.Storage/storageAccounts@2021-08-01' = {
  name: storageAccountName
  location: location
  kind: 'StorageV2'
  sku: {
    name: storageAccountSkuName
  }
  properties: {
    accessTier: 'Hot'
    supportsHttpsTrafficOnly: true
  }
}

output storageAccountId string = storageAccount.id
