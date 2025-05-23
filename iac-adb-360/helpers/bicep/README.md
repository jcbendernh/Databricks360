# Bicep Deployment Instructions

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
## 2. Create two service principals in your tenant (Microsoft Entra ID)
- service principal <b>devops-sc</b> (App Registration) used for the service connection in Azure Devops (ADO), which serves as the security context for the devops agent, running your pipelines
- service principal <b>adb360-sp</b> (App Registration) used for interaction with the Azure Databricks worspace and account . 


## 3. Set the parameters in the azuredeploy.paramters.json file
Modifying it like the code block below.

```json
    "parameters": {
        "location": {
            "value": "<your azure region>"
        },
        "serviceprincipaloid": {
            "value": "<devops-sc Service Principal Object ID>"
        },
        "adbspoid": {
            "value": "<adb360-sp Service Principal Object ID>"
        }

```

For a listing of Azure Region names, you can run the following Azure CLI command:

```sh
az account list-locations --query "[?metadata.geographyGroup=='US'].[name, displayName, metadata.geographyGroup]" -o table   
```
This shows a listing of US regions.

## 4. Deploy `rg-create.bicep`

This file is used to create the required Azure resources.<BR>  
NOTE: Please chnage location to match your location used above in the parameters file.

```sh
az deployment sub create --location <location> --template-file rg-create.bicep --parameters @azuredeploy.parameters.json

```

NOTE:  Sometimes the script has to be executed twice as the 'prd' resource group is not recognized immediately.  If you get a failure similar to below.  Wait 2 minutes and try again.<br>
*Resource group 'rg-eastus2-adb360-0523-prd' could not be found."*<br>

## 5. Verify Deployment

Check the Azure Portal or use the CLI to confirm resources and role assignments.  Below are some CLI Samples to verify the resource groups.

By default the resource group names are as follows...
- rg-<location>-adb360-<2 digit day value><2 digit month value>-dev
- rg-<location>-adb360-<2 digit day value><2 digit month value>-prd

For example, my resource groups were **rg-eastus2-adb360-0523-dev** and **rg-eastus2-adb360-0523-prd**.

### Check Resource group names

```sh
az group show --name <resource-group-name>

```

###  Check Service Principal Permissionss on the Resource Groups

```sh
az role assignment list --assignee <service-principal-object-id> --resource-group <resource-group-name> --output table
```

- **devops-sc** SPN: **Managed Identity Operator** and **Contributor** roles.<br>
- **adb360-sp** SPN: **Contributor** role.<br>

You have completed this section and can now return to the iac-adb-360 README for [Step 1. Standard installation (no SCC).](../../README.md#1-standard-installation-no-scc)