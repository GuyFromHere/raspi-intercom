Function Enable-GuestIntegration {
    param(
        [Parameter(Mandatory=$true)][string]$VMName
    )
    Try {
        Enable-VMIntegrationService -VMName $VMName -Name "Guest Service Interface"
    } 
    Catch {
        Write-Host "Enable-GuestIntegration: Unable to enable Guest Service Interface on $VMName."
    }
}