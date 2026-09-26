# RBAC – Container App to ACR

## Objective

Configure the Azure Container App to authenticate to Azure Container Registry using a system-assigned managed identity rather than registry admin credentials.

## Configuration

- Container App: `ca-skabiral-website`
- Container Registry: `acrskabiral`
- Identity: System-assigned managed identity
- Role: `AcrPull`
- Scope: Container Registry `acrskabiral`

## Access Flow

Container App  
→ System-assigned Managed Identity  
→ Azure RBAC (`AcrPull`)  
→ Azure Container Registry  
→ `skabiral-website:2.0`

## Verification

The RBAC assignment was verified using Azure CLI:

```bash
az role assignment list \
  --scope $(az acr show --name acrskabiral --query id -o tsv) \
  --role AcrPull \
  --assignee $(az containerapp identity show \
    --name ca-skabiral-website \
    --resource-group rg-container-platform \
    --query principalId -o tsv) \
  --output table

