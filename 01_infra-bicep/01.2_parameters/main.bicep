// Define parameters
param location string = resourceGroup().location

@allowed([
  'dev'
  'test'
  'prod'
])
@description('In terminal you will be asked, if the environment is prod or nonprod. type 1 or 2')
param environmentName string = 'dev'

@minLength(3)
@maxLength(8)
@description('You can assign a default value to a parameter')
param env string = 'dev'

@description('A unique name for the storage account')
param storageAccountName string = 'stgaccbicep${uniqueString(resourceGroup().id)}'

@minValue(1)
@maxValue(10)
param appServicePlanInstanceCount int = 1

@description('The name and tier of the App Service plan SKU')
param appServicePlanSku object

@secure()
@description('The administrator login username for the SQL server.')
param sqlServerAdministratorLogin string

@secure()
@description('The administrator login password for the SQL server.')
param sqlServerAdministratorPassword string

@description('The name and tier of the SQL database SKU.')
param sqlDatabaseSku object

@description('Object parameters for tags')
param resourceTags object = {
  env: 'dev'
  creator: 'memal7'
  CostCenter: '1000100'
  Team: 'Infra'
}

//////////////////////////////////////////////////////////////////////////////////////////////////

// Define the variables
@description('If the environment is prod, then the storage account type will be Standard_GRS, otherwise Standard_LRS')
var storageAccountSkuName = (environmentName == 'prod') ? 'Standard_GRS' : 'Standard_LRS'
var appServicePlanName = '${env}-asp-${uniqueString(resourceGroup().id)}'
var appServiceAppName = '${env}-asp-app-${uniqueString(resourceGroup().id)}'
var sqlServerName = '${environmentName}-${uniqueString(resourceGroup().id)}-sql'
var sqlDatabaseName = 'Employees'


//////////////////////////////////////////////////////////////////////////////////////////////////

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

// Create a SQL Server
resource sqlServer 'Microsoft.Sql/servers@2020-11-01-preview' = {
  name: sqlServerName
  location: location
  properties: {
    administratorLogin: sqlServerAdministratorLogin
    administratorLoginPassword: sqlServerAdministratorPassword
  }
}


// Create a SQL Database
resource sqlDatabase 'Microsoft.Sql/servers/databases@2020-11-01-preview' = {
  parent: sqlServer
  name: sqlDatabaseName
  location: location
  sku: {
    name: sqlDatabaseSku.name
    tier: sqlDatabaseSku.tier
  }
}


// Create an App Service Plan
resource appServicePlan 'Microsoft.Web/serverfarms@2020-06-01' = {
  name: appServicePlanName
  location: location
  tags: resourceTags
  sku: {
    name: appServicePlanSku.name
    tier: appServicePlanSku.tier
    capacity: appServicePlanInstanceCount
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


