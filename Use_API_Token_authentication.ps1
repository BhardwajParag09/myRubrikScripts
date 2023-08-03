$Token="eyJ0rz8"
Connect-Rubrik 10.X.X.X -Token $Token
$version = Get-RubrikVersion
Write-Output "The cluster version is" $version
