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

# Function for logging
Function LogWrite
{
    Param
    (
        [Parameter(Mandatory=$true, Position=0)]
        [string] $logstring,
        [Parameter(Mandatory=$false, Position=1)]
        [string] $level
    )
    switch ( $level )
    {
        "Info" { $logLevel = 1 }
        "Warning" { $logLevel = 2 }
        "Error" { $logLevel = 3 }
        default { $logLevel = 1 }
    }

    $logDate = Get-Date -Format "MM-dd-yyyy"
    $logTime = Get-Date -Format "HH:mm:ss.fff-00"
    $logstring = "<![LOG[$logstring]LOG]!><time=""$logTime"" date=""$logDate"" component=""Main"" context="""" type=""$logLevel"">"

    Add-Content $Logfile -Value $logstring
}

########################################################
# Main Script

$logDir = "C:\temp"
$Logfile = "$logDir\test.log"

LogWrite "Initialisation..."

# Check the presence of the "Debug_Window.ps1" script
    $scriptPath = ".\Debug_Window.ps1"
    if (Test-Path $scriptPath -PathType Leaf) {
        # Check the presence of the "test.log" journal file
        $logFilePath = "C:\temp\test.log"
        if (Test-Path $logFilePath -PathType Leaf) {
            # Launch the Debug_Window.ps1 script in a new PowerShell window with the name "Debug Console"
            Start-Process powershell -ArgumentList "-NoLogo -NoExit -File `"$scriptPath`" `"$Logfile`""

        } else {
            Write-Error "The test.log journal file does not exist at the specified location: $logFilePath"
            Exit 1
        }
    } else {
        Write-Error "The Debug_Window.ps1 script was not found at the specified location: $scriptPath"
        Exit 1
    }

Start-Sleep -Seconds 5
LogWrite "Script start..."

Add-Type -AssemblyName PresentationCore, PresentationFramework

# Load and display the GUI from the XAML file
    [xml]$XML = Get-Content -Path ".\Main.xaml"
    $FormXML = (New-Object System.Xml.XmlNodeReader $XML)
    $Window = [Windows.Markup.XamlReader]::Load($FormXML)

# Specify the path of your desired icon
    $iconPath = ".\Icon\16x16.ico"

# Check if the icon file exists before assigning it
    if (Test-Path $iconPath -PathType Leaf) {
        $Window.Icon = [System.Windows.Media.Imaging.BitmapFrame]::Create($iconPath)
        $Window.TaskbarItemInfo = New-Object System.Windows.Shell.TaskbarItemInfo
        $Window.TaskbarItemInfo.Description = "Your application description"
        $Window.TaskbarItemInfo.Overlay = [System.Windows.Media.Imaging.BitmapFrame]::Create($iconPath)
    } else {
        Write-Error "The icon was not found."
    }

# Retrieve the controls
    $TextBox_Name = $Window.FindName("TextBox_Name")
    $Label_Name = $Window.FindName("Label_Name")

    $TextBox_FirstName = $Window.FindName("TextBox_FirstName")
    $Label_FirstName = $Window.FindName("Label_FirstName")

# Event handler for the TextChanged event of TextBox_Name
    $TextBox_Name.add_TextChanged({
        $Label_Name.Content = $TextBox_Name.Text
        LogWrite "$($Label_Name.Content)"
    })

# Event handler for the TextChanged event of TextBox_FirstName
    $TextBox_FirstName.add_TextChanged({
        $Label_FirstName.Content = $TextBox_FirstName.Text
        LogWrite "$($Label_FirstName.Content)"
    })

# Add an event handler for the Closed event of the window
    $Window.Add_Closed({
        LogWrite "WPF window closed."
    })

$Window.ShowDialog() | Out-Null