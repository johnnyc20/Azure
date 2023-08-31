<#To create a virtual machine in Azure from scratch using PowerShell, you can follow these steps:

Install the Azure PowerShell module.
Connect to your Azure account using the Connect-AzAccount cmdlet.
Create a resource group using the New-AzResourceGroup cmdlet.
Create a virtual network using the New-AzVirtualNetwork cmdlet.
Create a subnet using the New-AzVirtualNetworkSubnetConfig cmdlet.
Create a public IP address using the New-AzPublicIpAddress cmdlet.
Create a network security group using the New-AzNetworkSecurityGroup cmdlet.
Create a virtual network interface card (NIC) using the New-AzNetworkInterface cmdlet.
Create a virtual machine configuration object using the New-AzVMConfig cmdlet.
Add a virtual hard disk (VHD) to the virtual machine configuration object using the Add-AzVMDataDisk cmdlet.
Create the virtual machine using the New-AzVM cmdlet.
Here is an example of how you can create a virtual machine in Azure from scratch using PowerShell:#>

# Install the Azure PowerShell module
Install-Module -Name Az -AllowClobber -Scope CurrentUser

# Connect to your Azure account
Connect-AzAccount

# Create a resource group
$resourceGroupName = "MyResourceGroup"
$location = "East US"
New-AzResourceGroup -Name $resourceGroupName -Location $location

# Create a virtual network
$vnetName = "MyVnet"
$vnetAddressPrefix = "10.0.0.0/16"
$subNetName = "MySubnet"
$subNetAddressPrefix = "10.0.0.0/24"
$subnet = New-AzVirtualNetworkSubnetConfig -Name $subNetName -AddressPrefix $subNetAddressPrefix
$vnet = New-AzVirtualNetwork -Name $vnetName -ResourceGroupName $resourceGroupName -Location $location -AddressPrefix $vnetAddressPrefix -Subnet $subnet

# Create a public IP address
$pipName = "MyPublicIp"
$pip = New-AzPublicIpAddress -Name $pipName -ResourceGroupName $resourceGroupName -Location $location -AllocationMethod Dynamic

# Create a network security group
$nsgName = "MyNsg"
$nsgRuleRdp = New-AzNetworkSecurityRuleConfig -Name "Allow-RDP"  -Protocol Tcp `
    -Direction Inbound `
    -Priority 100 `
    -SourceAddressPrefix * `
    -SourcePortRange * `
    -DestinationAddressPrefix * `
    -DestinationPortRange 3389 `
    -Access Allow

$nsgRuleHttp = New-AzNetworkSecurityRuleConfig -Name "Allow-HTTP"  -Protocol Tcp `
    -Direction Inbound `
    -Priority 200 `
    -SourceAddressPrefix * `
    -SourcePortRange * `
    -DestinationAddressPrefix * `
    -DestinationPortRange 80 `
    -Access Allow

$nsg = New-AzNetworkSecurityGroup -ResourceGroupName $resourceGroupName `
    -Location $location `
    -Name $nsgName `
    -SecurityRules $nsgRuleRdp,$nsgRuleHttp

# Create a virtual network interface card (NIC)
$nicName = "MyNic"
$nic = New-AzNetworkInterface `
    -ResourceGroupName $resourceGroupName `
    -Location $location `
    -Name $nicName `
    -SubnetId $vnet.Subnets[0].Id `
    -PublicIpAddressId $pip.Id `
    -NetworkSecurityGroupId $nsg.Id

# Create a virtual machine configuration object
$vmName = "MyVm"
$vmSize = "Standard_D2_v2"
$vmImagePublisher = "MicrosoftWindowsServer"
$vmImageOffer = "WindowsServer"
$vmImageSku = "2019-Datacenter"
$vmImageVersion = "latest"

$vmConfig = New-AzVMConfig `
    -VMName $vmName `
    -VMSize $vmSize |
        Set-AzVMOperatingSystem `
            # Set Windows as the operating system
            # and specify the version of Windows Server you want to use.
            # For example, Windows Server 2019 Datacenter.
            # You can find