# Create the dev environment in Hyper-v
# ATTENTION: RUN ELEVATED 

# Default Raspbian VM Properties
$ISOPath = "D:\Hyper-V\ISOs\2020-02-12-rpd-x86-buster.iso"
# Private switch for connecting the two VMs
$PrivateSwitchProperties = @{
    Name = "sw-prv-intercom";
    SwitchType = "private";
}
# Internal switch for communicating with dev environment
$InternalSwitchProperties = @{
    Name = "sw-int-intercom";
    SwitchType = "internal"
}
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

$Name = @("rasp-int-01", "rasp-int-02")
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
if (Get-VmSwitch $InternalSwitchProperties.Name) {
    Remove-VMSwitch -Name $InternalSwitchProperties.Name -Force
}
Sleep 3

# (Re)create switches from scratch
New-VMSwitch -Name $PrivateSwitchProperties.Name -SwitchType $PrivateSwitchProperties.SwitchType
New-VMSwitch -Name $InternalSwitchProperties.Name -SwitchType $InternalSwitchProperties.SwitchType

# Create internal NAT switches
$GwIp = "10.1.0.1"
$SnetPrefixLength = "24"
$SwitchName = "sw-nat-01"
$NatName = "nat-01"
$SnetPrefix = "10.1.0.0/" + $SnetPrefixLength
New-VMSwitch -SwitchName $SwitchName -SwitchType Internal
$NewNetAdapter = Get-NetAdapter | Sort -Property IfIndex | Select-Object -Last 1
New-NetIPAddress -IPAddress $GwIp -PrefixLength $SnetPrefixLength -InterfaceIndex $NewNetAdapter.ifIndex
# Configure NET network
New-NetNat -Name $NatName -InternalIPInterfaceAddressPrefix $SnetPrefix
<#
Remove-VMSwitch $SwitchName
Remove-NetIPAddress -IPAddress $GwIp
Remove-NetNat -Name $NatName
#>

$GwIp = "10.2.0.1"
$SnetPrefixLength = "24"
$SwitchName = "sw-nat-02"
$NatName = "nat-02"
$SnetPrefix = "10.2.0.0/" + $SnetPrefixLength
New-VMSwitch -SwitchName $SwitchName -SwitchType Internal
$NewNetAdapter = Get-NetAdapter | Sort -Property IfIndex | Select-Object -Last 1
New-NetIPAddress -IPAddress $GwIp -PrefixLength $SnetPrefixLength -InterfaceIndex $NewNetAdapter.ifIndex
# Configure NET network
New-NetNat -Name $NatName -InternalIPInterfaceAddressPrefix $SnetPrefix
<#
Remove-VMSwitch $SwitchName
Remove-NetIPAddress -IPAddress $GwIp
Remove-NetNat -Name $NatName
#>

# Now the VMs
$Name.ForEach{
    # Create VHD for each VM
    New-VHD -Path ($DefaultVHDProperties.VHDPath + $_ + ".vhdx") -SizeBytes $DefaultVHDProperties.VHDSizeBytes -Dynamic -BlockSizeBytes $DefaultVHDProperties.BlockSizeBytes
    # Create the VMs
    New-VM -Name $_ -MemoryStartupBytes $MemoryStartupBytes -SwitchName $PrivateSwitchProperties.Name -Generation $Generation -Path $VmPath -VHDPath ($DefaultVHDProperties.VHDPath + $_ + ".vhdx")
    Sleep 5
    # After a brief pause to let the last operation complete, add hardware components and start 'er up.
    Set-VMDvdDrive -VMName $_ -Path $ISOPath
    Add-VMNetworkAdapter -VMName $_ -SwitchName "sw-int-intercom" -Name "InternalNetwork"
    Start-VM -Name $_
}
