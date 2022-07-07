// Define parameters
param location string = resourceGroup().location

@allowed([
  'nonprod'
  'prod'
])
@description('In terminal you will be asked, if the environment is prod or nonprod. type 1 or 2')
param environmentName string = 'prod'


@description('A unique name for the storage account')
param storageAccountName string = 'stgaccbicep${uniqueString(resourceGroup().id)}'

// Define the variables
@description('If the environment is prod, then the storage account type will be Standard_GRS, otherwise Standard_LRS')
var storageAccountSkuName = (environmentName == 'prod') ? 'Standard_GRS' : 'Standard_LRS'

// Create a Storage Account
resource storageAccount 'Microsoft.Storage/storageAccounts@2021-08-01' = if (environmentName == 'prod'){
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

output storageInfo string = storageAccount.id
