param location string = resourceGroup().location

// It will ask in terminal, if the environment is prod or nonprod. Type 1 0r 2
@allowed([
  'nonprod'
  'prod'
])
param env string = 'nonprod'

param appServiceAppName string = 'appServiceBicep${uniqueString(resourceGroup().id)}'

var resourceTag = {
  Environment: env
  Application: 'SCM'
  Component: 'Common'
}

module servicebus 'servicebus.bicep' = {
  name: 'deployServiceBus'
  params: {
    env: env
    resourceTag: resourceTag
  }
}

module cosmos 'cosmosdb.bicep' = {
  name: 'deployCosmosAccount'
  params: {
    env: env
  }
}

// Create an App Service
module appService 'appserviceplan.bicep' = {
  name: 'appService'
  params: {
    location: location
    appServiceAppName: appServiceAppName
    environmentType: env
  }
}

output appServiceAppHostName string = appService.outputs.appServiceAppHostName
