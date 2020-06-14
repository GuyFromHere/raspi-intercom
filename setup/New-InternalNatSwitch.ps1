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
        $NewNetAdapter = Get-NetAdapter -Name "*$SwitchName*"
        New-NetIPAddress -IPAddress $GwIp -PrefixLength $SnetPrefixLength -InterfaceIndex $NewNetAdapter.ifIndex
        # Configure NET network
        New-NetNat -Name $NatName -InternalIPInterfaceAddressPrefix $SnetPrefix
    }
}