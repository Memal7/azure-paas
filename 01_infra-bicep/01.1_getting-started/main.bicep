// Define parameters
param storageAccountName string = 'stgaccbicep${uniqueString(resourceGroup().id)}'
param location string = 'North Europe'

// In terminal you will asked, if the environment is prod or nonprod. type 1 or 2
@allowed([
  'nonprod'
  'prod'
])
param environmentType string

@minLength(3)
@maxLength(8)
@description('Name of environment')
param env string = 'dev'

// Define the variables
@description('If the environment is prod, then the storage account type will be Standard_GRS, otherwise Standard_LRS')
var storageAccountSkuName = (environmentType == 'prod') ? 'Standard_GRS' : 'Standard_LRS'
var resourceTag = {
  Environment: env
  Creator: 'meaml7'
  purpose: 'have fun with bicep'
}


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
  tags: resourceTag
}

output storageAccountId string = storageAccount.id
