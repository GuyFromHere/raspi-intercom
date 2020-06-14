
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
        Remove-NetIPAddress -IPAddress $GwIp -Confirm:$False
        Remove-NetNat -Name $NatName -Confirm:$False
    }
}