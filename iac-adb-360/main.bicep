param baseName string
param env string = 'prd'
param location string = resourceGroup().location


var adbwsmngresid = '${subscription().id}/resourceGroups/${resourceGroup().name}-mng'
var locationshortstring = location == 'westus3'? 'wus3' : location == 'westus2'? 'wus2' : location == 'westus' ? 'wus' : location




module adb 'bmain-modules/adbws.bicep'={
  name: 'adbws'
  params: {
    baseName: baseName 
    env: env
    location: location
    adbmngresourceid: adbwsmngresid
    locationshortname: locationshortstring
    lawid: law.outputs.lawid
  }
}

module uami 'bmain-modules/accon.bicep' = {
  name: 'uami'
  params: {
    baseName: baseName 
    env: env
    location: location
    locationshortname: locationshortstring
  }
}


module dlg3 'bmain-modules/dlg3.bicep'={
  name: 'dlg3'
  params: {
    baseName: baseName 
    env: env
    location: location
    uamipid: uami.outputs.adbacpid
    lawid: law.outputs.lawid
  }
}




module law 'bmain-modules/law.bicep'={
  name: 'law'
  params: {
    baseName: baseName
    env: env
    location: location
    locationshortname: locationshortstring
  }
}
