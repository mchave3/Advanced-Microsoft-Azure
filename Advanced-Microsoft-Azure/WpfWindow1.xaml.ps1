function Add-ControlVariables {
	New-Variable -Name 'Button_Connection' -Value $window.FindName('Button_Connection') -Scope 1 -Force
}

[System.Reflection.Assembly]::LoadWithPartialName("PresentationFramework") | Out-Null

function Import-Xaml {
	[xml]$xaml = Get-Content -Path $PSScriptRoot\WpfWindow1.xaml
	$manager = New-Object System.Xml.XmlNamespaceManager -ArgumentList $xaml.NameTable
	$manager.AddNamespace("x", "http://schemas.microsoft.com/winfx/2006/xaml");
	$xaml.SelectNodes("//*[@x:Name='Button']", $manager)[0].RemoveAttribute('Click')
	$xaml.SelectNodes("//*[@x:Name='Button_Connection']", $manager)[0].RemoveAttribute('Click')
	$xamlReader = New-Object System.Xml.XmlNodeReader $xaml
	[Windows.Markup.XamlReader]::Load($xamlReader)
}
function Set-EventHandler {
	$Button_Connection.add_Click({
		param([System.Object]$sender,[System.Windows.RoutedEventArgs]$e)
		Click_connection -sender $sender -e $e
	})
}

$window = Import-Xaml

# Set the icon after importing the XAML
	$Icon = New-Object System.Windows.Media.Imaging.BitmapImage -ArgumentList (New-Object System.Uri "$PSScriptRoot\Icon\32x32.ico")
	$window.Icon = $Icon

# This is the toolbar icon and description
	$window.TaskbarItemInfo = New-Object System.Windows.Shell.TaskbarItemInfo
	$window.TaskbarItemInfo.Description = $window.Title
Add-ControlVariables
Set-EventHandler

function Click_connection
{
	param($sender, $e)
}


$window.ShowDialog()