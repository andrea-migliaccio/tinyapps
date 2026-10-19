@description('Name of the Azure Static Web App')
param swaName string = 'swa-tinyapps'

@description('Azure region for the resources')
param location string = 'westeurope'

@description('Custom domain to attach to the Static Web App (empty = none)')
param customDomain string = ''

@description('Set to true only after the DNS records (TXT/CNAME) for customDomain are in place. See infra/README.md')
param deployCustomDomain bool = false

@description('Deploy a Storage Account with a Tables service')
param deployStorage bool = false

@description('Name of the Storage Account (3-24 lowercase alphanumeric)')
param storageAccountName string = 'sttinyapps'

@description('Table Storage tables to create')
param tableNames array = []

@description('Tags applied to all resources')
param tags object = {
  project: 'tinyapps'
  environment: 'production'
}

// ---------------------------------------------------------------------------
// Static Web App (Free tier)
// ---------------------------------------------------------------------------
resource swa 'Microsoft.Web/staticSites@2023-01-01' = {
  name: swaName
  location: location
  tags: tags
  sku: {
    name: 'Free'
    tier: 'Free'
  }
  properties: {
    buildProperties: {
      skipGithubActionWorkflowGeneration: true
    }
  }
}

// Step 1: deploy with deployCustomDomain = false
// Step 2: configure DNS (see infra/README.md)
// Step 3: set deployCustomDomain = true and redeploy
resource domain 'Microsoft.Web/staticSites/customDomains@2023-01-01' = if (deployCustomDomain && !empty(customDomain)) {
  parent: swa
  name: customDomain
  properties: {}
}

// ---------------------------------------------------------------------------
// Storage Account (optional)
// ---------------------------------------------------------------------------
resource storageAccount 'Microsoft.Storage/storageAccounts@2023-01-01' = if (deployStorage) {
  name: storageAccountName
  location: location
  tags: tags
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties: {
    accessTier: 'Hot'
    allowBlobPublicAccess: false
    minimumTlsVersion: 'TLS1_2'
    supportsHttpsTrafficOnly: true
  }
}

resource tableService 'Microsoft.Storage/storageAccounts/tableServices@2023-01-01' = if (deployStorage) {
  parent: storageAccount
  name: 'default'
}

resource tables 'Microsoft.Storage/storageAccounts/tableServices/tables@2023-01-01' = [for t in tableNames: if (deployStorage) {
  parent: tableService
  name: t
}]

// ---------------------------------------------------------------------------
// Outputs
// ---------------------------------------------------------------------------
@description('Default hostname of the Static Web App — CNAME target for the custom domain')
output defaultHostname string = swa.properties.defaultHostname

@description('Resource ID of the Static Web App')
output swaResourceId string = swa.id
