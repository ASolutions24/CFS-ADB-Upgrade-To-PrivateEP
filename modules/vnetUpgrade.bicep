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

resource vnet 'Microsoft.Network/virtualNetworks@2021-03-01' existing = {
  name: existingVNETName
}

resource nsg 'Microsoft.Network/networkSecurityGroups@2023-09-01' = {
  name: nsgName
  location: location
  properties:{
        securityRules: [for nsgRule in nsgRules: {
            name:nsgRule.name
            properties:{
              description:nsgRule.description
              protocol: nsgRule.protocol
              sourcePortRange:nsgRule.sourcePortRange
              destinationPortRange:nsgRule.destinationPortRange
              sourceAddressPrefix:nsgRule.sourceAddressPrefix
              destinationAddressPrefix:nsgRule.destinationAddressPrefix
              access:nsgRule.access
              priority:nsgRule.priority
              direction:nsgRule.direction
              sourcePortRanges:nsgRule.sourcePortRanges
              destinationPortRanges:nsgRule.destinationPortRanges
              sourceAddressPrefixes:nsgRule.sourceAddressPrefixes
              destinationAddressPrefixes:nsgRule.destinationAddressPrefixes

          }
        }
      ]

  }
}

resource rt 'Microsoft.Network/routeTables@2023-09-01' = {
  name: rtName
  location: location
  properties: {
    disableBgpRoutePropagation:disableBgpRoutePropagation
    routes: [for route in routeTables: {
       name:route.name
       properties:{
         addressPrefix:route.addressPrefix
         nextHopType:route.nextHopType
         nextHopIpAddress:route.nextHopIpAddress
       }
    }]
  }
}


resource subnet 'Microsoft.Network/virtualNetworks/subnets@2023-09-01' = {
 parent: vnet
 name: adbPrivateEndpointSubnetName
 properties: {
   addressPrefix: adbprivateEndpointSubnetCidr
   networkSecurityGroup:{
    id:nsg.id
   }
   routeTable:{
    id:rt.id
   }    
   privateEndpointNetworkPolicies:'Enabled'
   privateLinkServiceNetworkPolicies:'Enabled'
 }
}






/*##############################################################
// Create nsg and nsg rule seperately
resource nsg 'Microsoft.Network/networkSecurityGroups@2023-09-01' = {
  name: nsgName
  location: location
}

param nsgRuleName string
param nsgRules array

resource nsgRule 'Microsoft.Network/networkSecurityGroups/securityRules@2023-09-01' = {
  name: 
   properties: {
        description: 'Required to restrict sources allowed to connect to ADB private endpoints.'
        protocol: '*'
        sourcePortRange: '*'
        destinationPortRange: '443'
        sourceAddressPrefix: 'VirtualNetwork'
        destinationAddressPrefix: '10.110.2.160/27'
        access: 'Allow'
        priority: 100
        direction: 'Inbound'
  }
}
*/
