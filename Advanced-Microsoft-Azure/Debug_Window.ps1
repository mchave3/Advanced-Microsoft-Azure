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

$logFilePath = "C:\temp\test.log"

if (Test-Path $logFilePath) {
    $watcher = New-Object System.IO.FileSystemWatcher
    $watcher.Path = (Get-Item $logFilePath).Directory.FullName
    $watcher.Filter = (Get-Item $logFilePath).Name
    $watcher.IncludeSubdirectories = $false

    $onChanged = Register-ObjectEvent $watcher "Changed" -SourceIdentifier FileChanged -Action {
        $content = Get-Content -Path $logFilePath | Select-Object -Last 1
        Write-Host $content
    }

    try {
        while ($true) {
            # Attendez indéfiniment les modifications du fichier
        }
    } finally {
        Unregister-Event -SourceIdentifier FileChanged
        $watcher.Dispose()
    }
} else {
    Write-Host "The specified log file does not exist."
}