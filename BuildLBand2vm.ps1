<#STEP-BY-STEP GUIDE: HOW TO SETUP AN AZURE LOAD BALANCER? (POWERSHELL GUIDE)
Posted by Dishan M. Francis | Jan 16, 2020 | Azure | 0  |     

Last Updated on January 16, 2020 by Dishan M. Francis

In my previous blog post https://www.rebeladmin.com/2020/01/step-step-guide-setup-azure-load-balancer/, I explained how to setup an Azure load balancer. In that post, I used GUI method to set it up. In this post I am going to show how we can set azure load balancer using Azure PowerShell. 

In this demo, I am going to set up two virtual servers with IIS on it. Then I am going to set up Azure load balancer and load balance the web service access for external connections over TCP port 80. 

To do that I will need to do the following tasks,

1. Setup new resource group

2. Setup two new windows VM

3. Setup IIS with sample web page

4. Create Azure load balancer

5. Create a backend pool

6. Create health probes

7. Create load balancer rule

8. Testing

For the configuration process, I will be using Azure PowerShell. Therefore, please make sure you have Azure PowerShell module installed. More info about it can find under https://docs.microsoft.com/en-us/powershell/azure/install-az-ps?view=azps-2.6.0

Setup new resource group

1. Launch PowerShell console and connect to Azure using Connect-AzAccount

2. Then create a new resource group using,#>

New-AzResourceGroup -Name REBELRG1 -Location "East US"

# In the above, REBELRG1 is the resource group name and East US is the resource group location.

<#Setup two new windows VM
1. In this demo, I am going to use two back end servers. Before VM setup, let's go ahead and create a new virtual network.#>

$vmsubnet  = New-AzVirtualNetworkSubnetConfig -Name vmsubnet -AddressPrefix "10.0.2.0/24"

New-AzVirtualNetwork -Name REBELVN1 -ResourceGroupName REBELRG1 -Location "East US" -AddressPrefix "10.0.0.0/16" -Subnet $vmsubnet

<#In the above, REBELVN1 is the new virtual network name. It has 10.0.0.0/16 address space. It also has a new subnet 10.0.2.0/24 (vmsubnet) for virtual machines.

2. Then I need to create a new availability set. To add back end servers to load balancer, those VMs need to be in the same availability set. #>

New-AzAvailabilitySet -Location "East US" -Name "REBELAS1" -ResourceGroupName "REBELRG1" -Sku aligned -PlatformFaultDomainCount 2 -PlatformUpdateDomainCount 2


<#In above REBELAS1 is the availability group name. More info about scale sets can found here https://docs.microsoft.com/en-us/azure/virtual-machine-scale-sets/availability

3. As the next step of the configuration, I am going to create two new virtual machines under REBELRG1 resource group. #>

$mylogin = Get-Credential

New-AzVm -ResourceGroupName REBELRG1 -Name "REBELTVM01" -Location "East US" -VirtualNetworkName "REBELVN1" -SubnetName "vmsubnet" -addressprefix 10.0.2.0/24 -PublicIpAddressName "REBELTVM01IP1" -AvailabilitySetName "REBELAS1" -OpenPorts 3389,80 -Image win2019datacenter -Size Standard_D2s_v3 -Credential $mylogin

New-AzVm -ResourceGroupName REBELRG1 -Name "REBELTVM02" -Location "East US" -VirtualNetworkName "REBELVN1" -SubnetName "vmsubnet" -addressprefix 10.0.2.0/24 -PublicIpAddressName "REBELTVM02IP1" -AvailabilitySetName "REBELAS1" -OpenPorts 3389,80 -Image win2019datacenter -Size Standard_D2s_v3 -Credential $mylogin

<#In the above, I am creating two virtual machines called REBELTVM01 & REBELTVM02. It is running windows server 2019 data center edition. I have specified it using -Image parameter. It also using Standard_D2s_v3 vm size. For networking, It uses REBELVN1 virtual network and subnet 10.0.2.0/24.

Setup IIS with sample web page

Now we have two VMs running. For testing purposes, I am going to set up a simple IIS web page in both VMs. To do that,

1. Log in to VM as a local administrator

2. Open PowerShell Console as Administrator

3. Run following to install the IIS role#>

Install-WindowsFeature -name Web-Server -IncludeManagementTools

#4. Then remove default IIS page using,

remove-item C:\inetpub\wwwroot\iisstart.htm

#5. As next step, create new content page using,

Add-Content -Path "C:\inetpub\wwwroot\iisstart.htm" -Value $("RebelAdmin LoadBalance Test " + $env:computername)

#6. After that, we can test it via a web browser.

#7. Follow the same steps and set up the IIS role in the second VM.

Create Azure load balancer

#1. The next step of the configuration is to set up an Azure load balancer. To do that run the following command,

New-AzLoadBalancer -Name "REBELLB01" -ResourceGroupName REBELRG1 -SKU Basic -Location "East US"

#In the above, we created a load balancer called "REBELLB01". It is a basic load balancer and using REBELRG1 resource group. 

#2. Load balancer is required front end ip address which will use by customers to connect from external networks. Before we configure this, we need public IP address in place. 

$publicIp = New-AzPublicIpAddress -ResourceGroupName REBELRG1 -Name 'REBELPublicIP1' -Location "East US" -AllocationMethod static -SKU Basic

#In the above we are creating a public ip address called REBELPublicIP1. The allocation method I used in here is static. 

#Once the public ip address is ready we can go ahead and add it to the load balancer config using,

$slb1 = Get-AzLoadBalancer -Name "REBELLB01" -ResourceGroupName "REBELRG1"

$slb1 | Add-AzLoadBalancerFrontendIpConfig -Name 'REBELFrontEndPool' -PublicIpAddress $publicIp

$slb1 | Set-AzLoadBalancer

#In the above, the first line retrieves the load balancer called REBELLB01 and stores it in $slb1 variable. In second line, I am using pipeline operator to add the load balancer front end ip configuration. In the third line, Set-AzLoadBalancer command is used to apply the new configuration to the load balancer and saves it.  

#Create a backend pool

#Now we have the front-end configuration. Let's go ahead and configure the back end pool. 

$slb2 = Get-AzLoadBalancer -Name "REBELLB01" -ResourceGroupName "REBELRG1"

$slb2 | Add-AzLoadBalancerBackendAddressPoolConfig -Name 'REBELBackEndPool'

$slb2 | Set-AzLoadBalancer

#This only creates the back-end pool. We still need to add the two VMs to it. 

#Before jump into actual configuration, first I need to prepare a few variables.

$mylb = Get-AzLoadBalancer -Name "REBELLB01" -ResourceGroupName "REBELRG1"

$ap = Get-AzLoadBalancerBackendAddressPoolConfig -Name "REBELBackEndPool" -LoadBalancer $mylb

#Then I need to find network interfaces related to the two VMs. We can do that using,

Get-AzNetworkInterface -ResourceGroupName "REBELRG1" | select Name

#Above command list down the network interfaces in REBELRG1 resource group. These names are equal to the actual VM name so it is easy to recognize. 
#Once correct interfaces are identified, we can update the LoadBalancerBackendAddressPools value of the network interface using, 

$nic1 = Get-AzNetworkInterface -ResourceGroupName "REBELRG1" -Name "REBELTVM01"

$nic1.IpConfigurations[0].LoadBalancerBackendAddressPools = $ap

$nic1 | Set-AzNetworkInterface

#In above, I assigned network interface of REBELTVM01 VM to REBELBackEndPool back end pool. 

#Let's use the same method and update the configuration of REBELTVM02 virtual network. 

$nic2 = Get-AzNetworkInterface -ResourceGroupName "REBELRG1" -Name "REBELTVM02"

$nic2.IpConfigurations[0].LoadBalancerBackendAddressPools = $ap

$nic2 | Set-AzNetworkInterface

# Create health probes

# We need health probs to monitor the service status of the back-end servers. To setup probe we can use,

$slb3 = Get-AzLoadBalancer -Name "REBELLB01" -ResourceGroupName "REBELRG1"

$slb3 | Add-AzLoadBalancerProbeConfig -Name "REBELHealthProbe" -RequestPath / -Protocol http -Port 80 -IntervalInSeconds 5 -ProbeCount 2

$slb3 | Set-AzLoadBalancer

# In the above, I created a probe called REBELHealthProbe. In this demo, we are running web service on TCP port 80. So we need to use the same for the probe. According to the above configuration, if a VM has 2 consecutive times out within 5 seconds, it will be removed from the load balancer distribution. 

# Create load balancer rule

# The load balancer rule defines how the traffic will be distributed from the load balancer to the back end pool. This is the last bit of configuration we required to get the load balancer up and running. 

# Before the actual configuration, I need to prepare few variables as follows,

$slb4 = Get-AzLoadBalancer -Name "REBELLB01" -ResourceGroupName "REBELRG1"

$fip = Get-AzLoadBalancerFrontendIpConfig -Name "REBELFrontEndPool" -LoadBalancer $slb4

$bip = Get-AzLoadBalancerBackendAddressPoolConfig -Name "REBELBackEndPool" -LoadBalancer $slb4

$pb = Get-AzLoadBalancerProbeConfig -Name "REBELHealthProbe" -LoadBalancer $slb4

# Then we can create the load balancer rule using,

$slb4 | Add-AzLoadBalancerRuleConfig -Name "REBELLBRule" -FrontendIpConfiguration $fip -BackendAddressPool $bip -Protocol Tcp -FrontendPort 80 -BackendPort 80 -Probe $pb

$slb4 | Set-AzLoadBalancer

# According to above config, any TCP 80 traffic which come to front end ip address will be distribute to back end pool members. #>