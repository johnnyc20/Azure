<#PowerShell script that creates an internal load balancer in Azure. You can use this script as a starting point and modify it according to your requirements.#>

# Create a resource group
New-AzResourceGroup -Name "myResourceGroup" -Location "EastUS"

# Create a virtual network
$vnet = New-AzVirtualNetwork `
  -ResourceGroupName "myResourceGroup" `
  -Location "EastUS" `
  -Name "myVnet" `
  -AddressPrefix "10.0.0.0/16"

# Create a subnet configuration
$subnetConfig = Add-AzVirtualNetworkSubnetConfig `
  -Name "myBackendSubnet" `
  -AddressPrefix "10.0.1.0/24" `
  -VirtualNetwork $vnet

# Create a public IP address for the load balancer
$publicIp = New-AzPublicIpAddress `
  -ResourceGroupName "myResourceGroup" `
  -Location "EastUS" `
  -Name "myPublicIp" `
  -AllocationMethod Static

# Create an internal load balancer configuration
$frontendIP = New-AzLoadBalancerFrontendIpConfig `
  -Name "myFrontendIp" `
  -PublicIpAddress $publicIp

$backendPool = New-AzLoadBalancerBackendAddressPoolConfig `
  -Name "myBackendPool"

$probe = New-AzLoadBalancerProbeConfig `
  -Name "myHealthProbe" `
  -Protocol Tcp `
  -Port 80 `
  -IntervalInSeconds 15 `
  -NumberOfProbes 2

$rule = New-AzLoadBalancerRuleConfig `
  -Name "myLoadBalancerRule" `
  -Protocol Tcp `
  -FrontendIpConfiguration $frontendIP `
  -BackendAddressPool $backendPool `
  -Probe $probe `
  -FrontendPort 80 `
  -BackendPort 80

$loadBalancer = New-AzLoadBalancer `
  -ResourceGroupName "myResourceGroup" `
  -Location "EastUS" `
  -Name "myLoadBalancer" `
  -FrontendIpConfiguration $frontendIP `
  -BackendAddressPool $backendPool `
  -Probe $probe `
  -LoadBalancingRule $rule

# Create two virtual machines
for ($i=1; $i-le2; $i++)
{
    # Create a NIC
    $nic = New-AzNetworkInterface `
      -ResourceGroupName "myResourceGroup" `
      -Location "EastUS" `
      -Name ("myNic{0}"-f$i) `
      -SubnetId $vnet.Subnets[0].Id

    # Create a virtual machine configuration
    $vmConfig = New-AzVMConfig `
      -VMName ("myVm{0}"-f$i) `
      -VMSize Standard_B1s |
      Set-AzVMOperatingSystem \
        -Windows \
        -ComputerName ("myVm{0}"-f$i) \
        -Credential (Get-Credential) |
      Set-AzVMSourceImage \
        -PublisherName MicrosoftWindowsServer \
        -Offer WindowsServer \
        -Skus latest \
        -Version latest |
      Add-AzVMNetworkInterface \
        -Id $nic.Id |
      Set-AzVMOSDisk \
        –CreateOption FromImage

    # Create the virtual machine
    New-AzVM –ResourceGroupName myResourceGroup –Location EastUS –VM $vmConfig
}
