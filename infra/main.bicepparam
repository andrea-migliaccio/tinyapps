using './main.bicep'

param swaName = 'swa-tinyapps'
param location = 'westeurope'
param customDomain = 'www.tinyapps.it'
// Set to true after the DNS records are configured (see infra/README.md)
param deployCustomDomain = true
param deployStorage = false
param storageAccountName = 'sttinyapps'
param tableNames = []
param tags = {
  project: 'tinyapps'
  environment: 'production'
}
