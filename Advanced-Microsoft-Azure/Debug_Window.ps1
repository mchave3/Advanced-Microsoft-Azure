############################################################################################################################
#
# Version : 1.0
#
# Created : dd/MM/YYYY
#
# Author : Mickael CHAVE
#
# Revisions:
# ----------
# 1.0    dd/MM/YYYY    Creation.
#
#
# Purpose : This script...
#
############################################################################################################################

param(
    [string]$logFilePath
)

if (Test-Path $logFilePath) {
    # Define a function to continuously read the log file
    function TailLog {
        $file = Get-Content $logFilePath -Wait
        foreach ($line in $file) {
            Write-Host $line
        }
    }

    # Call the TailLog function to track the log file in real-time
    TailLog
} else {
    Write-Host "The specified log file does not exist."
}