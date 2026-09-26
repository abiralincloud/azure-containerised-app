#!/bin/bash

RG="rg-container-platform"

echo "# Azure Container Platform Architecture"
echo
echo "Resource Group: $RG"
echo

echo "## Resources"
echo

az resource list \
  --resource-group "$RG" \
  --query "[].{Name:name,Type:type,Location:location}" \
  --output table

echo
echo "## Container Registry"
echo

az acr show \
  --name acrskabiral \
  --resource-group "$RG" \
  --query "{Name:name,LoginServer:loginServer,Sku:sku.name}" \
  --output table

echo
echo "Repositories:"
az acr repository list \
  --name acrskabiral \
  --output table

echo
echo "## Container App"
echo

az containerapp show \
  --name ca-skabiral-website \
  --resource-group "$RG" \
  --query "{
    Name:name,
    URL:properties.configuration.ingress.fqdn,
    Environment:properties.environmentId,
    ProvisioningState:properties.provisioningState,
    RevisionMode:properties.configuration.activeRevisionsMode
  }" \
  --output table

echo
echo "## Managed Identity"
echo

az containerapp identity show \
  --name ca-skabiral-website \
  --resource-group "$RG" \
  --query "{PrincipalId:principalId,Type:type}" \
  --output table

echo
echo "## ACR Pull Permission"
echo

az role assignment list \
  --scope "$(az acr show --name acrskabiral --query id -o tsv)" \
  --role AcrPull \
  --assignee "$(az containerapp identity show \
      --name ca-skabiral-website \
      --resource-group "$RG" \
      --query principalId -o tsv)" \
  --query "[].{Role:roleDefinitionName,Scope:scope}" \
  --output table

echo
echo "## Log Analytics"
echo

az monitor log-analytics workspace list \
  --resource-group "$RG" \
  --query "[].{Name:name,Location:location}" \
  --output table
