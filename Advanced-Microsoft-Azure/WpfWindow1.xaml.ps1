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

Add-Type -AssemblyName System.Windows.Forms

# Create a window
$Form = New-Object System.Windows.Forms.Form
$Form.Text = "Fenêtre de Débogage PowerShell"
$Form.Size = New-Object System.Drawing.Size(800,600)
$Form.StartPosition = "CenterScreen"

# Create a text box
$TextBox = New-Object System.Windows.Forms.TextBox
$TextBox.Multiline = $true
$TextBox.ScrollBars = "Vertical"
$TextBox.Dock = "Fill"

# Add the text box to the window
$Form.Controls.Add($TextBox)

# Define the function to read the log file
function Refresh-Log {
    $content = Get-Content -Path "C:\temp\test.log" -Tail 50
    $TextBox.Text = $content -join "`r`n"
}

# Refresh the content every few seconds
$Timer = New-Object System.Windows.Forms.Timer
$Timer.Interval = 500
$Timer.Add_Tick({
    Refresh-Log
})
$Timer.Start()

# Close the form
$Form.Add_Closed({
    $Timer.Stop()
})

$Form.ShowDialog()











# Import necessary libraries
[System.Reflection.Assembly]::LoadWithPartialName("PresentationFramework") | Out-Null

# Load the XAML file and create a window from it
function Import-Xaml {
	[xml]$xaml = Get-Content -Path $PSScriptRoot\WpfWindow1.xaml
	$manager = New-Object System.Xml.XmlNamespaceManager -ArgumentList $xaml.NameTable
	$manager.AddNamespace("x", "http://schemas.microsoft.com/winfx/2006/xaml");
	$xaml.SelectNodes("//*[@x:Name='Button_Connection']", $manager)[0].RemoveAttribute('Click')
	$xaml.SelectNodes("//*[@x:Name='TextBox_Name']", $manager)[0].RemoveAttribute('TextChanged')
	$xamlReader = New-Object System.Xml.XmlNodeReader $xaml
	[Windows.Markup.XamlReader]::Load($xamlReader)
}

# Create a new variable that is a reference to a button in the user interface
function Add-ControlVariables {
	New-Variable -Name 'Button_Connection' -Value $window.FindName('Button_Connection') -Scope 1 -Force	

	New-Variable -Name 'TextBox_Name' -Value $window.FindName('TextBox_Name') -Scope 1 -Force
	New-Variable -Name 'Lable_Name' -Value $window.FindName('Label_Name') -Scope 1 -Force
}

# Add an event handler to the 'Button_Connection' button
function Set-EventHandler {
	$TextBox_Name.add_TextChanged({
		param([System.Object]$sender,[System.Windows.Controls.TextChangedEventArgs]$e)
		Name_TextChanged -sender $sender -e $e
	})
	$Button_Connection.add_Click({
		param([System.Object]$sender,[System.Windows.RoutedEventArgs]$e)
		Click_Connection -sender $sender -e $e
	})
}

# Function called when the 'Button_Connection' button is clicked
function Click_connection {
	param($sender, $e)
}

# Import the XAML file and create a window
$window = Import-Xaml

# Set the window's icon
$Icon = New-Object System.Windows.Media.Imaging.BitmapImage -ArgumentList (New-Object System.Uri "$PSScriptRoot\Icon\32x32.ico")
$window.Icon = $Icon

# Set the window's description
$window.TaskbarItemInfo = New-Object System.Windows.Shell.TaskbarItemInfo
$window.TaskbarItemInfo.Description = $window.Title

# Add control variables and set event handlers
Add-ControlVariables
Set-EventHandler

function Name_TextChanged
{
	param($sender, $e)
	$Lable_Name = $TextBox_Name
}

# Display the window to the user
function Click_Connection
{
	param($sender, $e)
	$Lable_Name.Content = $TextBox_Name.text
}


$window.ShowDialog()



# Attendez la fin du script principal
Wait-Process -Id $PID

# Fermez la fenêtre de débogage à la fin du script principal
$DebugWindow.CloseMainWindow()