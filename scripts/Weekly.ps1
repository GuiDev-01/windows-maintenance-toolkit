$ScriptDirectory = Split-Path -Parent $MyInvocation.MyCommand.Path
$ProjectRoot = Split-Path -Parent $ScriptDirectory
$LogsDirectory = Join-Path $ProjectRoot "logs"

if (-Not (Test-Path $LogsDirectory)) {
    New-Item -ItemType Directory -Path $LogsDirectory | Out-Null
}

$LogFile = Join-Path $LogsDirectory "weekly-$(Get-Date -Format 'yyyy-MM-dd').log"

function Log($msg) {
    $line = "$(Get-Date -Format 'HH:mm:ss') - $msg"
    Write-Host $line
    Add-Content -Path $LogFile -Value $line
}

Log "Starting weekly cleanup..."

$DailyScript = Join-Path $ScriptDirectory "Daily.ps1"

if (Test-Path $DailyScript) {
    powershell.exe -ExecutionPolicy Bypass -File $DailyScript
} else {
    Log "Daily script not found. Skipping daily cleanup step."
}

Log "Checking Docker..."

if (Get-Command docker -ErrorAction SilentlyContinue) {
    try {
        $runningContainers = docker ps -q 2>$null

        if ($runningContainers) {
            Log "Docker has running containers. Skipping Docker cleanup."
        } else {
            Log "Cleaning Docker build cache..."
            docker builder prune -f

            Log "Cleaning unused Docker resources..."
            docker system prune -f
        }
    } catch {
        Log "Docker is not available or not running. Skipping Docker cleanup."
    }
} else {
    Log "Docker is not installed. Skipping Docker cleanup."
}

Log "Checking npm..."

if (Get-Command npm -ErrorAction SilentlyContinue) {
    Log "Verifying npm cache..."
    npm cache verify
} else {
    Log "npm is not installed. Skipping npm cleanup."
}

Log "Checking pnpm..."

if (Get-Command pnpm -ErrorAction SilentlyContinue) {
    Log "Cleaning pnpm store..."
    pnpm store prune
} else {
    Log "pnpm is not installed. Skipping pnpm cleanup."
}

Log "Weekly cleanup completed."