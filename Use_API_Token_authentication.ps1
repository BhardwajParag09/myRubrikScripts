$Token="eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiIzNOUskjdfghhskdjfhKJHDKJSHGDKJHAKJ"
Connect-Rubrik 10.38.X.X -Token $Token
$version = Get-RubrikVersion
Write-Output "The cluster version is" $version
