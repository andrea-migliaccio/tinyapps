# Infrastruttura Azure — tinyapps

Generata dalla skill `tinyapps-infra`. Risorse: resource group `rg-tinyapps`, Static Web App `swa-tinyapps`, identità OIDC `github-tinyapps-actions` (Contributor sul RG). Il workflow `deploy-infra.yml` applica `infra/main.bicep` a ogni push su `infra/**`.

## Custom domain (due fasi)

1. Recupera hostname e token di validazione:
   ```bash
   az staticwebapp show -n swa-tinyapps -g rg-tinyapps --query defaultHostname -o tsv
   ```
2. Dal pannello DNS aggiungi `CNAME www -> <defaultHostname>` (TTL 300) ed eventualmente il `TXT` di validazione mostrato da Azure Portal → SWA → Custom domains.
3. Dopo la propagazione imposta `deployCustomDomain = true` in `infra/main.bicepparam`, committa e pusha.

Errori comuni: `AuthorizationFailed` → ruolo Contributor mancante (rilancia `bootstrap.sh`); `CNAME Record is invalid` → DNS non ancora propagato.

## Cambio dominio
Imposta `deployCustomDomain = false` e push (rimuove il vecchio), cambia `customDomain`, ripeti DNS, poi `true`.

## Secret GitHub
| Secret | Origine |
|---|---|
| `AZURE_CLIENT_ID`, `AZURE_TENANT_ID`, `AZURE_SUBSCRIPTION_ID` | `bootstrap.sh` |
| `AZURE_STATIC_WEB_APPS_API_TOKEN` | `az staticwebapp secrets list -n swa-tinyapps -g rg-tinyapps --query properties.apiKey -o tsv` (dopo il primo deploy) |
