$ScriptDirectory = Split-Path -Parent $MyInvocation.MyCommand.Path
$ProjectRoot = Split-Path -Parent $ScriptDirectory
$LogsDirectory = Join-Path $ProjectRoot "logs"

if (-Not (Test-Path $LogsDirectory)) {
    New-Item -ItemType Directory -Path $LogsDirectory | Out-Null
}

$LogFile = Join-Path $LogsDirectory "monthly-$(Get-Date -Format 'yyyy-MM-dd').log"

function Log($msg) {
    $line = "$(Get-Date -Format 'HH:mm:ss') - $msg"
    Write-Host $line
    Add-Content -Path $LogFile -Value $line
}

Log "Starting monthly maintenance..."

$WeeklyScript = Join-Path $ScriptDirectory "Weekly.ps1"

if (Test-Path $WeeklyScript) {
    powershell.exe -ExecutionPolicy Bypass -File $WeeklyScript
} else {
    Log "Weekly script not found. Skipping weekly cleanup step."
}

Log "Running Windows component cleanup..."
DISM.exe /Online /Cleanup-Image /StartComponentCleanup

Log "Running System File Checker..."
sfc /scannow

Log "Shutting down WSL..."
wsl --shutdown

Log "WSL virtual disk optimization skipped."
Log "To enable it, edit Monthly.ps1 and configure your own ext4.vhdx path."

# Optional WSL VHDX optimization:
#
# Replace the path below with your own ext4.vhdx path and uncomment the command.
#
# Example:
#
# Optimize-VHD `
#   -Path "C:\Users\YourUser\AppData\Local\Packages\CanonicalGroupLimited.Ubuntu24.04LTS_xxxxxxxxx\LocalState\ext4.vhdx" `
#   -Mode Full

Log "Monthly maintenance completed."
Pause