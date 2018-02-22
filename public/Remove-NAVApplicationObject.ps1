function Remove-NAVApplicationObject {
  [CmdletBinding(DefaultParameterSetName = "All", SupportsShouldProcess = $true, ConfirmImpact = 'High')]
  Param(
    [Parameter(Mandatory = $true, Position = 0)]
    [string] $DatabaseName,
    [ValidateNotNullOrEmpty()]
    [string] $DatabaseServer = '.',
    [ValidateNotNullOrEmpty()]
    [string] $LogPath,
    [string] $Filter,
    [ValidateSet('Yes', 'No', 'Force')]
    [string] $SynchronizeSchemaChanges = 'Yes',
    [Parameter(Mandatory = $true, ParameterSetName = "DatabaseAuthentication")]
    [string] $Username,
    [Parameter(Mandatory = $true, ParameterSetName = "DatabaseAuthentication")]
    [string] $Password,
    [ValidateNotNullOrEmpty()]
    [string] $NavServerName,
    [ValidateNotNullOrEmpty()]
    [string] $NavServerInstance,
    [ValidateNotNullOrEmpty()]
    [int16]  $NavServerManagementPort)

  if ($PSCmdlet.ShouldProcess(
      "Delete application objects from $DatabaseName database.",
      "Delete application objects from $DatabaseName database.",
      'Confirm')) {
        
    $commands = @()
    $commands += "Command=DeleteObjects"
    $commands += "SynchronizeSchemaChanges={0}" -f $SynchronizeSchemaChanges
    if ($Filter) {
      $commands += 'Filter="{0}"' -f $Filter
    }

    try {
      Invoke-NAVIdeCommand -CommandList $commands `
        -DatabaseServer $DatabaseServer `
        -DatabaseName $DatabaseName `
        -Username $Username `
        -Password $Password `
        -NavServerName $NavServerName `
        -NavServerInstance $NavServerInstance `
        -NavServerManagementPort $NavServerManagementPort `
        -LogPath $LogPath `
        -ErrorText "Error while exporting $Filter" `
        -Verbose:$VerbosePreference
    }
    catch {
      Write-Error $PSItem
    }
  }
}