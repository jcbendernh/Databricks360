# Bicep Deployment Guide

This README provides step-by-step instructions to deploy the `re-create.bicep` and `role-assignment.bicep` files.

## Prerequisites

- [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli) installed
- [Bicep CLI](https://docs.microsoft.com/en-us/azure/azure-resource-manager/bicep/install) installed
- Sufficient Azure permissions to deploy resources and assign roles

## 1. Login to Azure

```sh
az login
```

## 2. Set the Subscription

```sh
az account set --subscription "<your-subscription-id>"
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
