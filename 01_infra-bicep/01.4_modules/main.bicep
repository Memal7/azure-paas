//////////////////////////////////////////// parameters //////////////////////////////////////////// 

param location string = resourceGroup().location

@allowed([
  'nonprod'
  'prod'
])
param env string = 'nonprod'

param appServiceAppName string = 'appServiceBicep${uniqueString(resourceGroup().id)}'


//////////////////////////////////////////// resources ////////////////////////////////////////////

// create commen tags
var resourceTag = {
  Environment: env
  Application: 'SCM'
  Component: 'Common'
}

// create a service bus namespace
module servicebus 'servicebus.bicep' = {
  name: 'deployServiceBus'
  params: {
    env: env
    resourceTag: resourceTag
  }
}

// create a cosmos db
module cosmos 'cosmosdb.bicep' = {
  name: 'deployCosmosAccount'
  params: {
    env: env
  }
}

// create an App Service
module appService 'appserviceplan.bicep' = {
  name: 'appService'
  params: {
    location: location
    appServiceAppName: appServiceAppName
    environmentType: env
  }
}


//////////////////////////////////////////// outputs //////////////////////////////////////////// 
output appServiceAppHostName string = appService.outputs.appServiceAppHostName
