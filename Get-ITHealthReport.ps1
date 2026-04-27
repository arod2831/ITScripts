Function Get-ITHealthReport {
    param($computer, $service)

    try {
        $ping = Test-Connection $computer -Count 4 -Quiet -ErrorAction Stop
        $ServiceStatus = Get-Service $service -ErrorAction Stop
        $time = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

        if ($ping) {
            Write-Output "$time, $computer is Online!" | Out-File -FilePath "C:\Users\Aldo\Downloads\logs.txt" -Append
            Write-Output "Online"
        } else {
            Write-Output "$time, $computer is Offline!" | Out-File -FilePath "C:\Users\Aldo\Downloads\logs.txt" -Append
            Write-Output "Offline"
        }

        if ($ServiceStatus.Status -eq "Running") {
            Write-Output "$time, $($ServiceStatus.Name) is Running" | Out-File -FilePath "C:\Users\Aldo\Downloads\logs.txt" -Append
        } else {
            Write-Output "$time, $($ServiceStatus.Name) is Not Running" | Out-File -FilePath "C:\Users\Aldo\Downloads\logs.txt" -Append
        }

    } catch {
        Write-Host "Error checking $computer : $($_.Exception.Message)"
        Write-Host "Error checking $service : $($_.Exception.Message)"
    }
}

Write-Host "Starting IT Health Check..."

$computers = @("8.8.8.8", (hostname))
$OnlineCounter = 0
$OfflineCounter = 0
$ComputerCounter = $computers.Count


foreach ($computer in $computers) {
    $result = Get-ithealthreport $computer -service "wuauserv"
    if ($result -eq "Online") {
        $OnlineCounter += 1
    } else {
        $OfflineCounter += 1
    }
}

Write-Output "--- Health Check Complete ---
Total computers checked: $ComputerCounter
Online : $OnlineCounter
Offline : $OfflineCounter" | Out-File -FilePath "C:\Users\Aldo\Downloads\logs.txt" -Append
#This was written by aldo
#This edit to show its pushed to github