function Show-Progress {
    param(
        [Parameter(Mandatory=$true)]
        [int]$Percent
    )

    $ProgressBarWidth = 50
    $CompleteWidth = [math]::Round($Percent * $ProgressBarWidth / 100)
    $IncompleteWidth = $ProgressBarWidth - $CompleteWidth

    $ProgressBar = "[" + "-" * $CompleteWidth + (" " * $IncompleteWidth) + "]"
    Write-Host "`r$ProgressBar $Percent% Complete" -NoNewline
}

# Exemple d'utilisation
for ($i = 0; $i -le 100; $i += 1) {
    Show-Progress -Percent $i
    Start-Sleep -Milliseconds 50
}
Write-Host "`nProcessus terminé!"