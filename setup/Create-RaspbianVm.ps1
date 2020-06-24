# Create the dev environment in Hyper-v
# ATTENTION: RUN ELEVATED 

param($Cleanup=$False)

<####
VM Properties
####>
# Default Raspbian VM Properties
$ISOPath = "D:\Hyper-V\ISOs\2020-02-12-rpd-x86-buster.iso"
$Name = @("rasp-int-01", "rasp-int-02")

# The New-VM command has issues with int values passed through a hash table
# so we have to define the VM properties individually. 
$StartupBytes = 512MB;
$MinimumBytes = 256MB;
$MaximumBytes = 1024MB;
$Generation = 1;
$VmPath = "D:\Hyper-V\VMs\Virtual Machines\";

$DefaultVHDProperties = @{
    VHDPath = "D:\Hyper-V\VMs\Hard Disks\";
    VHDSizeBytes = 10GB; 
    BlockSizeBytes = 1MB; 
}

<####
Switch Properties    
####>
# Internal switches with static NAT 
# Once created they can access the dev server on 10.1.0.1:3000 and 10.2.0.1:3000, respectively.
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

<####
Source Helper Functions
####>
# Source all ps1 files in the current directory except for this script
(Get-ChildItem -Path . -Exclude $MyInvocation.MyCommand | Where-Object{ $_.Name -like "*ps1" }).ForEach{ . $_.FullName }

<####
Cleanup 
####>
if ($Cleanup) {
    # Clean up VMs, switches, and hard drives before recreating them:
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
    if ( Get-VMSwitch $SwitchProperties01.SwitchName ) {
        Remove-NewInternalNatSwitch -NatName $SwitchProperties01.NatName -SwitchName $SwitchProperties01.SwitchName -GwIp $SwitchProperties01.GwIp
    }
    if ( Get-VMSwitch $SwitchProperties02.SwitchName ) {
        Remove-NewInternalNatSwitch -NatName $SwitchProperties02.NatName -SwitchName $SwitchProperties02.SwitchName -GwIp $SwitchProperties02.GwIp
    }
    Sleep 3
}


# Create Switches
New-InternalNatSwitch @SwitchProperties01
New-InternalNatSwitch @SwitchProperties02

# Now create the VMs
$Name.ForEach{
    $VmIdentifier = $_.Substring($_.length - 2)
    # Create VHD for each VM
    New-VHD -Path ($DefaultVHDProperties.VHDPath + $_ + ".vhdx") -SizeBytes $DefaultVHDProperties.VHDSizeBytes -Dynamic -BlockSizeBytes $DefaultVHDProperties.BlockSizeBytes
    # Create the VMs
    New-VM -Name $_ -Generation $Generation -Path $VmPath -VHDPath ($DefaultVHDProperties.VHDPath + $_ + ".vhdx")
    Set-VMMemory -VMName $_  -DynamicMemoryEnabled $true -MinimumBytes $MinimumBytes -StartupBytes $StartupBytes -MaximumBytes $MaximumBytes -Buffer 20 -Priority 50 
    Sleep 5
    # After a brief pause to let the last operation complete, add hardware components and start 'er up.
    Set-VMDvdDrive -VMName $_ -Path $ISOPath
    # Commenting out net adapter so we can add it after configuring vm with default adapter
    Add-VMNetworkAdapter -VMName $_ -SwitchName "sw-nat-$VmIdentifier" -Name "InternalNetwork"
    Start-VM -Name $_
}
