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
    $LogInfo = Set-LogPathVariables -LogPath $LogPath

    $LogInfo.CreatedFolder = Initialize-LogPath -LogPath $LogInfo.LogPath -CommandResultFile $LogInfo.CommandResultFile -NAVErrorLogFile $LogInfo.ErrorLogFile

    $Argument = Get-CommonFinSQLArgument -CommandList $CommandList `
      -DatabaseServer $DatabaseServer `
      -DatabaseName $DatabaseName `
      -Username $Username `
      -Password $Password `
      -ErrorLogFile $LogInfo.ErrorLogFile `
      -NavServerName $NavServerName `
      -NavServerInstance $NavServerInstance `
      -NavServerManagementPort $NavServerManagementPort

    Start-NAVIdeProcess -Argument $Argument

    $ErrorObject = Read-FinSQLResult -LogPath $LogInfo.LogPath `
      -CommandResultFile $LogInfo.CommandResultFile `
      -ErrorLogFile $LogInfo.ErrorLogFile `
      -CreatedFolder $LogInfo.CreatedFolder

    if (-not $errorobject.Successful) {
      $FullErrorMessage = '{0}: {1}' -f $ErrorText, $ErrorObject.ErrorMessage
      throw $FullErrorMessage
    }
  }
}