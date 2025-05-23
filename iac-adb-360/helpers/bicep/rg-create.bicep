targetScope='subscription'

param solutionname string = 'adb360'
param location string 
param serviceprincipalname string = 'devops-sc'
param serviceprincipaloid string 
param adbinteractprincipalname string = 'adb360-sp'
param adbspoid string
param currentDate string = utcNow('yyyy-MM-ddTHH:mm:ssZ')

var month = substring(currentDate, 5, 2)
var day = substring(currentDate, 8, 2)

var dailysolutionname = '${solutionname}-${day}${month}' 
var rgDev = 'rg-${location}-${dailysolutionname}-dev'
var rgPrd = 'rg-${location}-${dailysolutionname}-prd'

resource rgDevResourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: rgDev
  location: location
}

resource rgPrdResourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: rgPrd
  location: location
}

module devRoleAssignments 'role-assignment.bicep' = {
  name: 'devRoleAssignments'
  scope: resourceGroup(rgDev)
  params: {
    resourceGroupName: rgDev
    serviceprincipalname: serviceprincipalname
    serviceprincipaloid: serviceprincipaloid
    adbinteractprincipalname: adbinteractprincipalname
    adbspoid: adbspoid
  }
}

module prdRoleAssignments 'role-assignment.bicep' = {
  name: 'prdRoleAssignments'
  scope: resourceGroup(rgPrd)
  params: {
    resourceGroupName: rgPrd
    serviceprincipalname: serviceprincipalname
    serviceprincipaloid: serviceprincipaloid
    adbinteractprincipalname: adbinteractprincipalname
    adbspoid: adbspoid
  }
}
