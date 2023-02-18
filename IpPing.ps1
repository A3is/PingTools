$ips = Select-String -Path "iplist.txt" -Pattern "\b\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\b" | Select-Object -ExpandProperty Matches | Select-Object -ExpandProperty Value
$output = @()
$errorIPs = @()

foreach ($ip in $ips) {
    $ping = Test-Connection $ip -Count 1
    if ($ping.StatusCode -eq 0) {
        $output += New-Object PSObject -Property @{
            IP = $ip
            MS = $ping.ResponseTime
        }
    } else {
        $errorIPs += "$ip - Error"
    }
}

$output = $output | Sort-Object -Property MS
$output = $output | ForEach-Object { "$($_.IP) - $($_.MS) ms" }
$output += $errorIPs

Set-Content "ip/$(Get-Date -Format 'yyyy-MM-dd-HH-mm').txt" $output
