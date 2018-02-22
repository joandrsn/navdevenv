function Initialize-LogPath {
  [CmdletBinding()]
  Param(
    [Parameter(Mandatory)]
    [String] $LogPath,
    [Parameter(Mandatory)]
    [String] $CommandResultFile,
    [Parameter(Mandatory)]
    [String] $NAVErrorLogFile
  )
  Process {
    
    Remove-Item $CommandResultFile -ErrorAction Ignore
    Remove-Item $NAVErrorLogFile -ErrorAction Ignore

    $createdFolder = $false
    if (-not (Test-Path -Path $LogPath -PathType Container)) {
      Write-Verbose "Creating the LogPath:`n$LogPath"
      $null = New-Item -Path $LogPath -ItemType Directory
      $createdFolder = $true
    }
    Write-Output $createdFolder
  }
}