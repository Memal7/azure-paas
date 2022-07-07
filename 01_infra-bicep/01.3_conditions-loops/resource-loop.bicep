param storageAccountNames array = [
  'saauditus'
  'saauditeurope'
  'saauditapac'
]

param locations array = [
  'westeurope'
  'eastus2'
  'eastasia'
]

@secure()
@description('The administrator login username for the SQL server.')
param administratorLogin string

@secure()
@description('The administrator login password for the SQL server.')
param administratorLoginPassword string

param location string = resourceGroup().location

// 3 storage accounts
resource storageAccount2 'Microsoft.Storage/storageAccounts@2021-01-01' = [for storageAccountName in storageAccountNames: {
  name: storageAccountName
  location: location
  kind: 'StorageV2'
  sku: {
    name: 'Standard_LRS'
  }
}]


// Iterate through arrays and retrieve the index of the current element in the array, e.g. sqlserver-1, sqlserver-2, ...
resource sqlServers 'Microsoft.Sql/servers@2020-11-01-preview' = [for (location, i) in locations: {
  name: 'sqlserver-${i+1}'
  location: location
  properties: {
    administratorLogin: administratorLogin
    administratorLoginPassword: administratorLoginPassword
  }
}]
