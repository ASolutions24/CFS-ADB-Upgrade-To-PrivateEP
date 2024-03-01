param existingVNETName string //= 'vnet-sec-dbw-prod'
param adbPrivateEndpointSubnetName string //= 'sn-test-newsubnet'
param adbprivateEndpointSubnetCidr string //= '10.110.2.160/27'

resource vnet 'Microsoft.Network/virtualNetworks@2021-03-01' existing = {
  name: existingVNETName
}

resource subnet 'Microsoft.Network/virtualNetworks/subnets@2023-09-01' = {
 parent: vnet
 name: adbPrivateEndpointSubnetName
 properties: {
   addressPrefix: adbprivateEndpointSubnetCidr 
   privateEndpointNetworkPolicies:'Enabled'
   privateLinkServiceNetworkPolicies:'Enabled'
 }
}
