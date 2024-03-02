//Subnet
param existingVNETName string //= 'vnet-sec-dbw-prod'
param adbPrivateEndpointSubnetName string //= 'sn-test-newsubnet'
param adbprivateEndpointSubnetCidr string //= '10.110.2.160/27'

//NSG 
param nsgName string //= 'nsg-test'
param location string //= 'australiaeast' 
param nsgRules array

//Route Table
param rtName string
param routeTables array
param disableBgpRoutePropagation bool


module vnetUpgrade './modules/vnetUpgrade.bicep' = {
  name:'deployVnetUpgrade'
  params: {
     existingVNETName:existingVNETName
     adbPrivateEndpointSubnetName:adbPrivateEndpointSubnetName
     adbprivateEndpointSubnetCidr:adbprivateEndpointSubnetCidr

     nsgName:nsgName
     location:location
     nsgRules:nsgRules

     rtName:rtName
     routeTables:routeTables
     disableBgpRoutePropagation:disableBgpRoutePropagation
  }

}
