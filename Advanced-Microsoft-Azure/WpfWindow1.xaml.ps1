[System.Reflection.Assembly]::LoadWithPartialName("PresentationFramework") | Out-Null

function Import-Xaml {
	[xml]$xaml = Get-Content -Path $PSScriptRoot\WpfWindow1.xaml
	$manager = New-Object System.Xml.XmlNamespaceManager -ArgumentList $xaml.NameTable
	$manager.AddNamespace("x", "http://schemas.microsoft.com/winfx/2006/xaml");
	$xamlReader = New-Object System.Xml.XmlNodeReader $xaml
	[Windows.Markup.XamlReader]::Load($xamlReader)
}

$window = Import-Xaml

# Set the icon after importing the XAML
$Icon = New-Object System.Windows.Media.Imaging.BitmapImage -ArgumentList (New-Object System.Uri "$PSScriptRoot\Icon\32x32.ico")
$window.Icon = $Icon

# This is the toolbar icon and description
$window.TaskbarItemInfo = New-Object System.Windows.Shell.TaskbarItemInfo
$window.TaskbarItemInfo.Description = $window.Title

$window.ShowDialog()