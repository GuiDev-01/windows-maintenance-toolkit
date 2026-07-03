$ScriptDirectory = Split-Path -Parent $MyInvocation.MyCommand.Path
$ProjectRoot = Split-Path -Parent $ScriptDirectory
$LogsDirectory = Join-Path $ProjectRoot "logs"

if (-Not (Test-Path $LogsDirectory)) {
    New-Item -ItemType Directory -Path $LogsDirectory | Out-Null
}

$LogFile = Join-Path $LogsDirectory "daily-$(Get-Date -Format 'yyyy-MM-dd').log"

function Log($msg) {
    $line = "$(Get-Date -Format 'HH:mm:ss') - $msg"
    Write-Host $line
    Add-Content -Path $LogFile -Value $line
}

Log "Starting daily cleanup..."

Start-Sleep -Seconds 30

Log "Cleaning user TEMP files..."
Remove-Item "$env:TEMP\*" -Recurse -Force -ErrorAction SilentlyContinue

Log "Cleaning Windows TEMP files..."
Remove-Item "C:\Windows\Temp\*" -Recurse -Force -ErrorAction SilentlyContinue

Log "Cleaning Recycle Bin..."
Clear-RecycleBin -Force -ErrorAction SilentlyContinue

Log "Cleaning thumbnail cache..."
Remove-Item "$env:LOCALAPPDATA\Microsoft\Windows\Explorer\thumbcache_*.db" -Force -ErrorAction SilentlyContinue

Log "Cleaning local temporary files..."
Remove-Item "$env:LOCALAPPDATA\Temp\*" -Recurse -Force -ErrorAction SilentlyContinue

Log "Flushing DNS cache..."
ipconfig /flushdns | Out-Null

Log "Daily cleanup completed."