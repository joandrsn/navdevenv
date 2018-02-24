function Read-FinSQLResult
{
  [CmdletBinding()]
  Param(
    [Parameter(Mandatory)]
    [string] $ErrorLogFile
  )
  Process
  {
    [boolean] $Successful = $true

    if (Test-Path $ErrorLogFile) {
      $ErrorContent = Get-Content $ErrorLogFile -Raw
      $ErrorMessage = $ErrorContent -replace "`r[^`n]", "`r`n"

      $Successful = $false
    }

    $result = [PSCustomObject]@{
      Successful   = $Successful
      ErrorMessage = $ErrorMessage
    }
    Write-Output $result
  }
}