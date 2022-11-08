$TargetCollection = "MyCollection"
$TargetProcess = "*"

# Extra step just to validate the Collection before we proceed
$RDSCollection = Get-RDSSessionCollection -CollectionName $TargetCollection

# Get the RDS session list, then check on each user/host for processes
$sessions = Get-RDUserSession -CollectionName $RDSCollection.CollectionName
$sessions | ForEach-Object {
    $CurrentHost = $_.HostServer
    $CurrentUser = $_.UserName

    RemoteProcesses = @()
    Parameters = @{
        ComputerName = $CurrentHost
        ScriptBlock = {
            $RemoteProcesses = Get-Process -IncludeUserName
            return $RemoteProcesses
        }
    }
    $RemoteProcesses = Invoke-Command @Parameters
    Write-Host "----------------------------------"
    Write-Host "Processes for $($CurrentUser) on $($CurrentHost):"
    Write-Host ""
    $RemoteProcesses | Where-Object {
        ($_.UserName - match $CurrentUser) -and ($_.ProcessName -like $TargetProcess)
    }
    Write-Host ""
    Write-Host ""
}
