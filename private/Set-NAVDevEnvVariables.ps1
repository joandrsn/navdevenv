function Set-NAVDevEnvVariables
{
  [CmdletBinding()]
  Param(
    [Parameter()]
    [String] $LogPath
  )
  Process
  {
    if (-not $LogPath) {
      $LogPath = Join-Path $env:TEMP "NavIdeResult"
    }
    $CommandResultFile = Join-Path $LogPath "navcommandresult.txt"
    $ErrorLogFile = Join-Path $LogPath "naverrorlog.txt"
    $IDFileName = '{0}.zup' -f $(New-Guid)
    $ID = Join-Path $env:TEMP $IDFileName

    $Result = [PSCustomObject]@{
      LogPath           = $LogPath
      CommandResultFile = $CommandResultFile
      ErrorLogFile      = $ErrorLogFile
      CreatedFolder     = $false
      ID                = $ID
    }
    Write-Output $Result
  }
}