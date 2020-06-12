# Create the dev environment in Hyper-v
# ATTENTION: RUN ELEVATED 

####
# VMs
# Default Raspbian VM Properties
$ISOPath = "D:\Hyper-V\ISOs\2020-02-12-rpd-x86-buster.iso"
$Name = @("rasp-int-01", "rasp-int-02")

# The New-VM command has issues with int values passed through a hash table
# so we have to define the VM properties individually. 
$MemoryStartupBytes = 1024MB;
$Generation = 1;
$VmPath = "D:\Hyper-V\VMs\Virtual Machines\";

$DefaultVHDProperties = @{
    VHDPath = "D:\Hyper-V\VMs\Hard Disks\";
    VHDSizeBytes = 10GB; 
    BlockSizeBytes = 1MB; 
}

####
# Switches
# Private switch for connecting the two VMs
# Once created they can access the dev server on 10.1.0.1:3000 and 10.2.0.1:3000, respectively.
$PrivateSwitchProperties = @{
    Name = "sw-prv-intercom";
    SwitchType = "private";
}

# Internal switches with static NAT 
$SwitchProperties01 = @{
    GwIp = "10.1.0.1";
    SnetPrefixLength = "24";
    SwitchName = "sw-nat-01";
    NatName = "nat-01";
    SnetPrefix = "10.1.0.0";
}
$SwitchProperties02 = @{
    GwIp = "10.2.0.1";
    SnetPrefixLength = "24";
    SwitchName = "sw-nat-02";
    NatName = "nat-02";
    SnetPrefix = "10.2.0.0";
}

####
# Functions
Function Remove-NewInternalNatSwitch {
    <#
    .SYNOPSIS
    Remove a custom static NAT virtual switch for Hyper-V
    
    .PARAMETER SwitchName
    Name of the switch you want to remove.
    
    .PARAMETER GwIp
    IP of the VM you want to remove.
    
    .PARAMETER NatName
    Name of the NAT object you want to remove.
    
    .EXAMPLE
    Remove-NewInternalNatSwitch -NatName "nat-01" -SwitchName "sw-01" -GwIp "10.0.0.1"    
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$True,HelpMessage="Name of the switch you want to remove.")][string]$SwitchName,
        [Parameter(Mandatory=$True,HelpMessage="IP of the VM you want to remove.")][string]$GwIp,
        [Parameter(Mandatory=$True,HelpMessage="Name of the NAT object you want to remove.")][string]$NatName
    )
    Process {
        Remove-VMSwitch $SwitchName -Force
        Remove-NetIPAddress -IPAddress $GwIp
        Remove-NetNat -Name $NatName
    }
}

Function New-InternalNatSwitch{
    <#
    .SYNOPSIS
    Short description
    
    .DESCRIPTION
    Long description
    
    .PARAMETER GwIp
    Parameter description
    
    .PARAMETER SnetPrefixLength
    Parameter description
    
    .PARAMETER SnetPrefix
    Parameter description
    
    .PARAMETER SwitchName
    Parameter description
    
    .PARAMETER NatName
    Parameter description
    
    .EXAMPLE
    An example
    
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true,HelpMessage="Static gateway IP for the new switch.")][string]$GwIp,
        [Parameter(Mandatory=$true,HelpMessage="Subnet prefix length for the switch subnet. ex: '24'")][string]$SnetPrefixLength,
        [Parameter(Mandatory=$true,HelpMessage="Subnet prefix for the new virtual network. ex: 10.0.0.0")][string]$SnetPrefix,
        [Parameter(Mandatory=$true,HelpMessage="Name of the new vSwitch in HyperV")][string]$SwitchName,
        [Parameter(Mandatory=$true,HelpMessage="Name of the new NAT object")][string]$NatName
    )
    Begin {
        $SnetPrefix = $SnetPrefix + "/" + $SnetPrefixLength
    }
    Process {
        New-VMSwitch -SwitchName $SwitchName -SwitchType Internal
        # Get most recent net adapter
        $NewNetAdapter = Get-NetAdapter | Sort-Object -Property IfIndex | Select-Object -Last 1
        New-NetIPAddress -IPAddress $GwIp -PrefixLength $SnetPrefixLength -InterfaceIndex $NewNetAdapter.ifIndex
        # Configure NET network
        New-NetNat -Name $NatName -InternalIPInterfaceAddressPrefix $SnetPrefix
    }
}

# Delete VMs, switches, and hard drives before recreating them:
$Name.ForEach{
    if (Get-VM -Name $_) {
        Stop-Vm -Name $_ -Force
        Remove-Vm -Name $_ -Force
    }
    if ( Test-Path -Path ($DefaultVHDProperties.VHDPath + $_ + ".vhdx") ) {
        Remove-Item -Path ($DefaultVHDProperties.VHDPath + $_ + ".vhdx")
    }
    Sleep 3
}
if (Get-VmSwitch $PrivateSwitchProperties.Name) {
    Remove-VMSwitch -Name $PrivateSwitchProperties.Name -Force
}
if ( Get-VMSwitch $SwitchProperties01.SwitchName ) {
    Remove-NewInternalNatSwitch -NatName $SwitchProperties01.NatName -SwitchName $SwitchProperties01.SwitchName -GwIp $SwitchProperties01.GwIp
}
if ( Get-VMSwitch $SwitchProperties02.SwitchName ) {
    Remove-NewInternalNatSwitch -NatName $SwitchProperties02.NatName -SwitchName $SwitchProperties02.SwitchName -GwIp $SwitchProperties02.GwIp
}
Sleep 3

# (Re)create switches from scratch
New-VMSwitch -Name $PrivateSwitchProperties.Name -SwitchType $PrivateSwitchProperties.SwitchType
New-InternalNatSwitch @SwitchProperties01
New-InternalNatSwitch @SwitchProperties02

# Create internal NAT switches
<# 
$GwIp = "10.1.0.1"
$SnetPrefixLength = "/24"
$SwitchName = "sw-nat-01"
$NatName = "nat-01"
$SnetPrefix = "10.1.0.0" + $SnetPrefixLength 
New-VMSwitch -SwitchName $SwitchName -SwitchType Internal
$NewNetAdapter = Get-NetAdapter | Sort-Object -Property IfIndex | Select-Object -Last 1
New-NetIPAddress -IPAddress $GwIp -PrefixLength $SnetPrefixLength -InterfaceIndex $NewNetAdapter.ifIndex
New-NetNat -Name $NatName -InternalIPInterfaceAddressPrefix $SnetPrefix
#>
<# 
# Uncomment to remove switch 
Remove-VMSwitch $SwitchName
Remove-NetIPAddress -IPAddress $GwIp
Remove-NetNat -Name $NatName
#>

<# $GwIp = "10.2.0.1"
$SnetPrefixLength = "24"
$SwitchName = "sw-nat-02"
$NatName = "nat-02"
$SnetPrefix = "10.2.0.0/" + $SnetPrefixLength
New-VMSwitch -SwitchName $SwitchName -SwitchType Internal
$NewNetAdapter = Get-NetAdapter | Sort-Object -Property IfIndex | Select-Object -Last 1
New-NetIPAddress -IPAddress $GwIp -PrefixLength $SnetPrefixLength -InterfaceIndex $NewNetAdapter.ifIndex
New-NetNat -Name $NatName -InternalIPInterfaceAddressPrefix $SnetPrefix #>
<#
Remove-VMSwitch $SwitchName
Remove-NetIPAddress -IPAddress $GwIp
Remove-NetNat -Name $NatName
#>

# Now the VMs
$Name.ForEach{
    $VmIdentifier = $_.Substring($_.length - 2)
    # Create VHD for each VM
    New-VHD -Path ($DefaultVHDProperties.VHDPath + $_ + ".vhdx") -SizeBytes $DefaultVHDProperties.VHDSizeBytes -Dynamic -BlockSizeBytes $DefaultVHDProperties.BlockSizeBytes
    # Create the VMs
    New-VM -Name $_ -MemoryStartupBytes $MemoryStartupBytes -SwitchName $PrivateSwitchProperties.Name -Generation $Generation -Path $VmPath -VHDPath ($DefaultVHDProperties.VHDPath + $_ + ".vhdx")
    Sleep 5
    # After a brief pause to let the last operation complete, add hardware components and start 'er up.
    Set-VMDvdDrive -VMName $_ -Path $ISOPath
    Add-VMNetworkAdapter -VMName $_ -SwitchName "sw-nat-$VmIdentifier" -Name "InternalNetwork"
    Start-VM -Name $_
}
