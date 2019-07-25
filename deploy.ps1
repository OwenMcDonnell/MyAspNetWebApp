write-host "hello from deployment"
$vars = Get-Content .\vars.json | ConvertFrom-Json
$env:var1 = $vars.var1
$env:var2 = $vars.var2
