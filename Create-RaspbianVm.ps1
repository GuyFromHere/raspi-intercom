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

$DefaultVmProperties = @{
    MemoryStartupBytes = "1024MB";
    SwitchName = "intercomswitch";
    Generation = "1";
    Path = "D:\Hyper-V\VMs\Virtual Machines\";
}

$DefaultVHDProperties = @{
    VHDPath = "D:\Hyper-V\VMs\Hard Disks\";
    VHDSizeBytes = 10GB; 
}

$Name = @("rasp-int-01", "rasp-int-02")
# Delete VMs before recreating them:
$Name.ForEach{
    if (Get-VM -Name $_) {
        Remove-Vm -Name $_ -Force
        if ( Test-Path -Path ($DefaultVHDProperties.VHDPath + $_ + ".vhdx") ) {
            Remove-Item -Path ($DefaultVHDProperties.VHDPath + $_ + ".vhdx")
        }
    }
    Sleep 5
}
if (Get-VmSwitch $PrivateSwitchProperties.Name) {
    Remove-VMSwitch -Name $PrivateSwitchProperties.Name -Force
}
if (Get-VmSwitch $InternalSwitchProperties.Name) {
    Remove-VMSwitch -Name $InternalSwitchProperties.Name -Force
}
Sleep 5
New-VMSwitch -Name $PrivateSwitchProperties.Name -SwitchType $PrivateSwitchProperties.SwitchType
New-VMSwitch -Name $InternalSwitchProperties.Name -SwitchType $InternalSwitchProperties.SwitchType
$Name.ForEach{
    New-VM -Name $_ -MemoryStartupBytes 1024MB -SwitchName $PrivateSwitchProperties.Name -Generation 1 -Path $DefaultVmProperties.Path 
    New-VHD -Path ($DefaultVHDProperties.VHDPath + $_ + ".vhdx") -SizeBytes $DefaultVHDProperties.VHDSizeBytes
    Sleep 10
    Set-VMHardDiskDrive -VMName $_ -Path ($DefaultVHDProperties.VHDPath + $_ + ".vhdx")
    Set-VMDvdDrive -VMName $_ -Path $ISOPath
    Add-VMNetworkAdapter -VMName $_ -SwitchName "sw-int-intercom" -Name "InternalNetwork"
    Start-VM -Name $_
}
