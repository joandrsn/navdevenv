function Read-FinSQLResult
{
  [CmdletBinding()]
  Param(
    [Parameter(Mandatory)]
    [string] $LogPath,
    [Parameter(Mandatory)]
    [string] $CommandResultFile,
    [Parameter(Mandatory)]
    [string] $ErrorLogFile,
    [Parameter(Mandatory)]
    [boolean] $CreatedFolder
  )
  Process
  {
    [boolean] $Successful = $true

    if (Test-Path $ErrorLogFile) {
      $ErrorContent = Get-Content $ErrorLogFile -Raw
      $ErrorMessage = $ErrorContent -replace "`r[^`n]", "`r`n"
      
      $Successful = $false
    }
    if ($CreatedFolder) {
      Remove-Item -Recurse -ErrorAction Ignore -Path $LogPath
    }

    Remove-Item -Path $ErrorLogFile -ErrorAction Ignore
    Remove-Item -Path $CommandResultFile -ErrorAction Ignore

    $result = [PSCustomObject]@{
      Successful   = $Successful
      ErrorMessage = $ErrorMessage
    }
    Write-Output $result
  }
} 