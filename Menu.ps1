$ProjectRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$ScriptsPath = Join-Path $ProjectRoot "scripts"

function Show-Menu {
    Clear-Host

    Write-Host ""
    Write-Host "====================================================" -ForegroundColor Cyan
    Write-Host "           Windows Maintenance Toolkit              " -ForegroundColor Cyan
    Write-Host "                    Version 1.0.0                   " -ForegroundColor DarkGray
    Write-Host "====================================================" -ForegroundColor Cyan

    Write-Host ""
    Write-Host " Maintenance" -ForegroundColor Yellow
    Write-Host " --------------------------------------------------"
    Write-Host "  [1] Run Daily Cleanup"
    Write-Host "  [2] Run Weekly Cleanup"
    Write-Host "  [3] Run Monthly Maintenance"

    Write-Host ""
    Write-Host " Automation" -ForegroundColor Yellow
    Write-Host " --------------------------------------------------"
    Write-Host "  [4] Enable Automatic Daily Cleanup"
    Write-Host "  [5] Enable Automatic Weekly Cleanup"

    Write-Host ""
    Write-Host " Scheduled Tasks" -ForegroundColor Yellow
    Write-Host " --------------------------------------------------"
    Write-Host "  [6] Disable Daily Cleanup"
    Write-Host "  [7] Disable Weekly Cleanup"

    Write-Host ""
    Write-Host " Exit" -ForegroundColor Yellow
    Write-Host " --------------------------------------------------"
    Write-Host "  [0] Exit"

    Write-Host ""
}

function Run-Script($scriptName) {
    $script = Join-Path $ScriptsPath $scriptName

    if (-Not (Test-Path $script)) {
        Write-Host ""
        Write-Host "Script not found: $script" -ForegroundColor Red
        Pause
        return
    }

    Write-Host ""
    Write-Host "Running $scriptName..." -ForegroundColor Cyan
    Write-Host ""

    powershell.exe -ExecutionPolicy Bypass -File $script

    Write-Host ""
    Write-Host "Operation completed." -ForegroundColor Green
    Pause
}

function Register-DailyTask {
    $script = Join-Path $ScriptsPath "Daily.ps1"

    $action = New-ScheduledTaskAction `
        -Execute "powershell.exe" `
        -Argument "-ExecutionPolicy Bypass -WindowStyle Hidden -File `"$script`""

    $trigger = New-ScheduledTaskTrigger -AtLogOn

    $principal = New-ScheduledTaskPrincipal `
        -UserId $env:USERNAME `
        -RunLevel Highest

    Register-ScheduledTask `
        -TaskName "Windows Maintenance Toolkit - Daily" `
        -Action $action `
        -Trigger $trigger `
        -Principal $principal `
        -Force | Out-Null

    Write-Host ""
    Write-Host "Automatic daily cleanup enabled successfully." -ForegroundColor Green
    Pause
}

function Register-WeeklyTask {
    $script = Join-Path $ScriptsPath "Weekly.ps1"

    $action = New-ScheduledTaskAction `
        -Execute "powershell.exe" `
        -Argument "-ExecutionPolicy Bypass -WindowStyle Hidden -File `"$script`""

    $trigger = New-ScheduledTaskTrigger `
        -Weekly `
        -DaysOfWeek Sunday `
        -At 12:00PM

    $principal = New-ScheduledTaskPrincipal `
        -UserId $env:USERNAME `
        -RunLevel Highest

    Register-ScheduledTask `
        -TaskName "Windows Maintenance Toolkit - Weekly" `
        -Action $action `
        -Trigger $trigger `
        -Principal $principal `
        -Force | Out-Null

    Write-Host ""
    Write-Host "Automatic weekly cleanup enabled successfully." -ForegroundColor Green
    Pause
}

function Disable-Task($taskName) {
    $task = Get-ScheduledTask -TaskName $taskName -ErrorAction SilentlyContinue

    if ($task) {
        Unregister-ScheduledTask -TaskName $taskName -Confirm:$false

        Write-Host ""
        Write-Host "Scheduled task removed successfully." -ForegroundColor Green
    } else {
        Write-Host ""
        Write-Host "No scheduled task found." -ForegroundColor Yellow
    }

    Pause
}

$exit = $false

do {
    Show-Menu
    $choice = Read-Host "Choose an option"

    switch ($choice) {
        "1" { Run-Script "Daily.ps1" }
        "2" { Run-Script "Weekly.ps1" }
        "3" { Run-Script "Monthly.ps1" }

        "4" { Register-DailyTask }
        "5" { Register-WeeklyTask }

        "6" { Disable-Task "Windows Maintenance Toolkit - Daily" }
        "7" { Disable-Task "Windows Maintenance Toolkit - Weekly" }

        "0" {
            $exit = $true
        }

        default {
            Write-Host ""
            Write-Host "Invalid option. Please try again." -ForegroundColor Red
            Pause
        }
    }
} while (-not $exit)