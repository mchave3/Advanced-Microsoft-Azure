############################################################################################################################
#
# Version: 1.0
#
# Created: 24/10/2023
#
# Author: Mickael CHAVE
#
# Revisions:
# ----------
# 1.0    24/10/2023    Creation.
#
#
# Purpose: This script provides a debug console for monitoring and parsing log files.
#
############################################################################################################################


param($logFilePath)

# Set debug preference to "Continue" for enhanced debugging
$DebugPreference = "Continue"

# Display welcome message and system information
Write-Host "| ********************************************" -ForegroundColor White
Write-Host "|   Welcome to the PowerShell Debug Console" -ForegroundColor White
Write-Host "| ********************************************" -ForegroundColor White
Write-Host "| Date: $(Get-Date)" -ForegroundColor White
Write-Host "| User: $env:USERNAME" -ForegroundColor White
Write-Host "| Computer: $env:COMPUTERNAME" -ForegroundColor White
Write-Host "| ********************************************`n" -ForegroundColor White

$regex = '<!\[LOG\[(.*?)\]LOG\]!\>\<time="(\d{2}:\d{2}:\d{2}\.\d{3}-\d{2})" date="(\d{2}-\d{2}-\d{4})" component="(.*?)" context="" type="(\d)"\>'

# Check if the log file exists
if (Test-Path $logFilePath) {
    # Monitor and parse the log file content
    Get-Content $logFilePath -wait -tail 0 | ForEach-Object {
        if ($_ -match $regex) {
            $logString = $Matches[1]
            $logTime = $Matches[2].Substring(0, 8)
            $logLevel = $Matches[5]

            # Display logs with different colors based on their log levels
            if ($logLevel -ne 3) {
                if ($logLevel -eq 2) {
                    Write-Host "WARNING : $logTime | $logString" -ForegroundColor Yellow
                }
                else {
                    Write-Host "INFO    : $logTime | $logString" -ForegroundColor White
                }
            }
            else {
                Write-Host "ERROR   : $logTime | $logString" -ForegroundColor Red
            }
        }
    }
} else {
    # Display an error message if the log file does not exist
    Write-Host "The specified log file does not exist."
}