Connect-AzAccount

# New-AzResourceGroup -Name "MyResourceGroup" -Location "East US"

New-AzResourceGroup -Name "MyResourceGroup" -Location "East US" -Tag @{ Environment = "Production"; Department = "IT" }

# New-AzResourceGroup -Name "MyResourceGroup" -Location "East US" -Tag @{ Environment = "Production"; Department = "IT" }

$frontendSubnet = New-AzVirtualNetworkSubnetConfig -Name "Frontend" -AddressPrefix "10.0.1.0/24"
$backendSubnet = New-AzVirtualNetworkSubnetConfig -Name "Backend" -AddressPrefix "10.0.2.0/24"

New-AzVirtualNetwork -Name "MyVirtualNetwork" -ResourceGroupName "MyResourceGroup" -Location "East US" -AddressPrefix "10.0.0.0/16" -Subnet $frontendSubnet,$backendSubnet

