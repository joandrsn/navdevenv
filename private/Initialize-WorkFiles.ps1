function Initialize-WorkFiles {
  [CmdletBinding()]
  Param(
    [Parameter(Mandatory)]
    [PSCustomObject] $Variables
  )
  Process {

    Remove-Item $Variables.CommandResultFile -ErrorAction Ignore
    Remove-Item $Variables.ErrorLogFile -ErrorAction Ignore
    Remove-Item $Variables.ID -ErrorAction Ignore

    $createdFolder = $false
    if (-not (Test-Path -Path $Variables.LogPath -PathType Container)) {
      Write-Verbose "Creating the LogPath:`n$LogPath"
      $null = New-Item -Path $Variables.LogPath -ItemType Directory
      $createdFolder = $true
    }
    Write-Output $createdFolder
  }
}