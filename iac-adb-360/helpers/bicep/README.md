# Bicep Deployment Guide

This README provides step-by-step instructions to deploy the `re-create.bicep` and `role-assignment.bicep` files.

## Prerequisites

- [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli) installed
- [Bicep CLI](https://docs.microsoft.com/en-us/azure/azure-resource-manager/bicep/install) installed
- Sufficient Azure permissions to deploy resources and assign roles. <BR>
    To create a resource group, your account must have the following permission:

    Microsoft.Resources/subscriptions/resourceGroups/write
    This permission is included in the following built-in roles:
    - Owner
    - Contributor
    - Resource Group Contributor (if scoped at the subscription level)<br>&nbsp;<br>
    If you're using custom roles, ensure they include the above operation

## 1. Login to Azure

```sh
az login --tenant  "<your-tenant-id>"
```

## 2. Set the parameters in the rg-create file by opening it and modifying lines 4 through 8.

```bicep
param location string = '<your azure region>'
param serviceprincipalname string = 'devops-sc'
param serviceprincipaloid string = '<devops-sc Service Principal Object ID>' //Service Principal Object ID
param adbinteractprincipalname string = 'adb360-sp'
param adbspoid string = '<adb360-sp Service Principal Object ID>'  //Service Principal Object ID
```

## 3. Deploy `re-create.bicep`

This file is used to (re)create the required Azure resources.

```sh
az deployment sub create \
    --location <location> \
    --template-file re-create.bicep \
    --parameters <parameters-file>.json
```

Replace `<location>` and `<parameters-file>.json` as needed.

## 4. Deploy `role-assignment.bicep`

This file assigns the necessary roles to the resources.

```sh
az deployment sub create \
    --location <location> \
    --template-file role-assignment.bicep \
    --parameters <parameters-file>.json
```

## 5. Verify Deployment

Check the Azure Portal or use the CLI to confirm resources and role assignments.

---

## Notes

- Ensure parameter files contain all required values.
- Review outputs and errors after each deployment step.
