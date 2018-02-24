$VerbosePreference = "Continue"

$variables = Join-Path $PSScriptRoot "variables.ps1"
. $variables

$module = Join-Path $PSScriptRoot "NAVDevEnv.psm1"
Import-Module $module

#Export-NAVApplicationObject -DatabaseName $Database -Path "COD50000.txt" -Filter "ID=50000"
#Start-NAVIDE -DatabaseName $Database
