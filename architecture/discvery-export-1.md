admin_abi [ ~ ]$ ./architecture/discover.sh
# Azure Container Platform Architecture

Resource Group: rg-container-platform

## Resources

Name                              Type                                      Location
--------------------------------  ----------------------------------------  -------------
acrskabiral                       Microsoft.ContainerRegistry/registries    australiaeast
workspacergcontainerplatform934c  Microsoft.OperationalInsights/workspaces  australiaeast
cae-container-platform            Microsoft.App/managedEnvironments         australiaeast
ca-skabiral-website               Microsoft.App/containerApps               australiaeast

## Container Registry

Name         LoginServer             Sku
-----------  ----------------------  -----
acrskabiral  acrskabiral.azurecr.io  Basic

Repositories:
Result
----------------
skabiral-website

## Container App

Name                 URL                                                                           Environment                                                                                                                                                  ProvisioningState    RevisionMode
-------------------  ----------------------------------------------------------------------------  -----------------------------------------------------------------------------------------------------------------------------------------------------------  -------------------  --------------
ca-skabiral-website  ca-skabiral-website.lemonisland-4e073e48.australiaeast.azurecontainerapps.io  /subscriptions/1ebd2d71-f4cc-4536-b36d-0e86da464d80/resourceGroups/rg-container-platform/providers/Microsoft.App/managedEnvironments/cae-container-platform  Succeeded            Single

## Managed Identity

PrincipalId                           Type
------------------------------------  --------------
92503296-16c9-4df8-944b-41b67de5b52f  SystemAssigned

## ACR Pull Permission

Role     Scope
-------  -----------------------------------------------------------------------------------------------------------------------------------------------------
AcrPull  /subscriptions/1ebd2d71-f4cc-4536-b36d-0e86da464d80/resourceGroups/rg-container-platform/providers/Microsoft.ContainerRegistry/registries/acrskabiral

## Log Analytics

Name                              Location
--------------------------------  -------------
workspacergcontainerplatform934c  australiaeast
admin_abi [ ~ ]$ 