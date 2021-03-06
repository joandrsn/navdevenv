function Export-NAVApplicationObject {
  [CmdletBinding(DefaultParameterSetName = "All")]
  Param(
    [Parameter(Mandatory = $true, Position = 0)]
    [string] $DatabaseName,
    [Parameter(Mandatory = $true, Position = 1)]
    [string] $Path,
    [ValidateNotNullOrEmpty()]
    [string] $DatabaseServer = '.',
    [string] $LogPath,
    [ValidateNotNullOrEmpty()]
    [string] $Filter,
    [switch] $ExportTxtUnlicensed,
    [Parameter(Mandatory = $true, ParameterSetName = "DatabaseAuthentication")]
    [string] $Username,
    [Parameter(Mandatory = $true, ParameterSetName = "DatabaseAuthentication")]
    [string] $Password,
    [ValidateNotNullOrEmpty()]
    [string] $NavServerName,
    [ValidateNotNullOrEmpty()]
    [string] $NavServerInstance,
    [ValidateNotNullOrEmpty()]
    [int16]  $NavServerManagementPort
  )
  Process {

    $skipUnlicensed = 1
    if ($ExportTxtUnlicensed) {
      $skipUnlicensed = 0
    }
  
    $commands = @()
    $commands += "Command=ExportObjects"
    $commands += "ExportTxtSkipUnlicensed={0}" -f $skipUnlicensed
    $commands += 'File="{0}"' -f $Path
    if ($Filter) {
      $commands += 'Filter="{0}"' -f $Filter
    }
  
    try {
      Invoke-NAVIdeCommand -CommandList $commands `
        -DatabaseServer $DatabaseServer `
        -DatabaseName $DatabaseName `
        -LogPath $LogPath `
        -Username $Username `
        -Password $Password `
        -NavServerName $NavServerName `
        -NavServerInstance $NavServerInstance `
        -NavServerManagementPort $NavServerManagementPort `
        -ErrorText "Error while exporting $Filter" `
        -Verbose:$VerbosePreference
    }
    catch {
      Write-Error $PSItem
    }
  }
}