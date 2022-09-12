/*
########## When to use parameter and when variables? ##########
A parameter lets you bring in valves from outside the bicep.
Use parameters when things changes between each deployment:
- The names of resources that need to be unique
- Locations into which to deploy the resources
- Settings that affect the pricing of resources, like their SKUs, pricing tiers, and instance counts
- Credentials and information needed to access other systems that aren't defined in the template

Use variables when the values are the same for each deployment:
Variables let you store important information in one place and refer to it throughout
the template without having to copy and paste it.
- Names  of the resources which shouldn't be unique
- Location of resources when it doesn't change in each deployment
- Reuseable values within the template
*/

// Define parameters
param storageAccountName string = 'stgaccbicep${uniqueString(resourceGroup().id)}'
param location string = resourceGroup().location

@allowed([
  'nonprod'
  'prod'
])
@description('In terminal you will be asked, if the environment is prod or nonprod. type 1 or 2')
param environmentType string

@minLength(3)
@maxLength(8)
@description('You can assign a default value to a parameter.')
param env string = 'dev'

@description('Object parameter for ASP sku')
param appServicePlanSku object = {
  name: 'F1'
  tier: 'Free'
  capacity: 1
}

@description('Object parameters for tags')
param resourceTags object = {
  env: 'dev'
  creaor: 'memal7'
  CostCenter: 1000100
  Team: 'Infra'
}


// Define the variables
@description('If the environment is prod, then the storage account type will be Standard_GRS, otherwise Standard_LRS')
var storageAccountSkuName = (environmentType == 'prod') ? 'Standard_GRS' : 'Standard_LRS'
var appServicePlanName = '${env}-asp-${uniqueString(resourceGroup().id)}'
var appServiceAppName = '${env}-asp-app-${uniqueString(resourceGroup().id)}'


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
  tags: resourceTags
}

output storageAccountId string = storageAccount.id

// Create an App Service Plan
resource appServicePlan 'Microsoft.Web/serverfarms@2020-06-01' = {
  name: appServicePlanName
  location: location
  tags: resourceTags
  sku: {
    name: appServicePlanSku.name
  }
}

// Create an App Service App
resource appServiceApp 'Microsoft.Web/sites@2020-06-01' = {
  name: appServiceAppName
  location: location
  tags: resourceTags
  kind: 'app'
  properties: {
      serverFarmId: appServicePlan.id
  }
}
