$VerbosePreference = "Continue"

$variables = Join-Path $PSScriptRoot "variables.ps1"
. $variables

$module = Join-Path $PSScriptRoot "NAVDevEnv.psm1"
Import-Module $module
Start-NAVIde -DatabaseName $database
