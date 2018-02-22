function Set-LogPathVariables
{
  [CmdletBinding()]
  Param(
    [Parameter()]
    [String] $LogPath
  )
  Process
  {
    if (-not $LogPath) {
      $LogPath = Join-Path $Env:TEMP "NavIdeResult"
    }
    $CommandResultFile = Join-Path $LogPath "navcommandresult.txt"
    $ErrorLogFile = Join-Path $LogPath "naverrorlog.txt"
    
    $Result = [PSCustomObject]@{
      LogPath           = $LogPath
      CommandResultFile = $CommandResultFile
      ErrorLogFile      = $ErrorLogFile
      CreatedFolder     = $false
    }
    Write-Output $Result
  }
}