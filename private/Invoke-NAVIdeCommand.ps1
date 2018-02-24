function Invoke-NAVIdeCommand {
  [CmdletBinding(DefaultParameterSetName = 'All')]
  Param(
    [string[]] $CommandList,
    [string] $DatabaseServer,
    [Parameter(Mandatory)]
    [string] $DatabaseName,
    [string] $Username,
    [string] $Password,
    [string] $NavServerName,
    [string] $NavServerInstance,
    [int16]  $NavServerManagementPort = 7045,
    #[ValidateScript({Test-Path -Path $PSItem -PathType -Container})]
    [string] $LogPath,
    [Parameter(Mandatory)]
    [string] $ErrorText)
  Process {
    Test-NavIde
    $NavDevEnvVariables = Set-NAVDevEnvVariables -LogPath $LogPath

    $NavDevEnvVariables.CreatedFolder = Initialize-WorkFiles -Variables $NavDevEnvVariables

    $Argument = Get-CommonFinSQLArgument -CommandList $CommandList `
      -DatabaseServer $DatabaseServer `
      -DatabaseName $DatabaseName `
      -Username $Username `
      -Password $Password `
      -ErrorLogFile $NavDevEnvVariables.ErrorLogFile `
      -NavServerName $NavServerName `
      -NavServerInstance $NavServerInstance `
      -NavServerManagementPort $NavServerManagementPort `
      -ID $NavDevEnvVariables.ID

    Start-NAVIdeProcess -Argument $Argument

    $ErrorObject = Read-FinSQLResult -ErrorLogFile $NavDevEnvVariables.ErrorLogFile
    Remove-Workfiles -Variables $NavDevEnvVariables

    if (-not $errorobject.Successful) {
      $FullErrorMessage = '{0}: {1}' -f $ErrorText, $ErrorObject.ErrorMessage
      throw $FullErrorMessage
    }
  }
}