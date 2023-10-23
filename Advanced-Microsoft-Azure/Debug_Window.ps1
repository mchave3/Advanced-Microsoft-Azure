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

$DebugPreference = "Continue"

$logFilePath = "C:\temp\test.log"
$regex = '<!\[LOG\[(.*?)\]LOG\]!\>\<time="(\d{2}:\d{2}:\d{2}\.\d{3}-\d{2})" date="(\d{2}-\d{2}-\d{4})" component="(.*?)" context="" type="(\d)"\>'
if (Test-Path $logFilePath) {
    Get-Content $logFilePath -wait -tail 0 | ForEach-Object {
        if ($_ -match $regex) {
            $logString = $Matches[1]
            $logTime = $Matches[2].Substring(0, 8)
            Write-Debug "$logTime | $logString"
        }
    }
} else {
    Write-Host "The specified log file does not exist."
}
