function Invoke-NAVIdeCommand {
  [CmdletBinding(DefaultParameterSetName = 'All')]
  Param(
    [Parameter(Mandatory)]
    [string] $Command,
    [string] $DatabaseServer,
    [Parameter(Mandatory)]
    [string] $DatabaseName,
    [string] $Username,
    [string] $Password,
    #[ValidateScript({Test-Path -Path $PSItem -PathType -Container})]
    [string] $LogPath,
    [Parameter(Mandatory)]
    [string] $ErrorText,
    [string] $NavServerName,
    [string] $NavServerInstance,
    [int16]  $NavServerManagementPort = 7045)
  Process {
    Test-NavIde

    if(!($LogPath)) {
      $LogPath = Join-Path $Env:TEMP "NavIdeResult"
      if(Test-Path $LogPath -PathType Container) {
        Remove-Item $LogPath -Force
      }
    }
    [bool]$createdFolder = $false
    if(!(Test-Path -Path $LogPath -PathType Container)) {
      Write-Verbose "Creating the LogPath:`n$LogPath"
      $null = New-Item -Path $LogPath -ItemType Directory
      $createdFolder = $true
    }
    $CommandResultFile = Join-Path $LogPath "navcommandresult.txt"
    $NAVErrorLogFile = Join-Path $LogPath "naverrorlog.txt"
    
    Remove-Item $CommandResultFile -ErrorAction Ignore
    Remove-Item $NAVErrorLogFile -ErrorAction Ignore

    $parameters = @()
    $parameters += $Command
    $parameters += 'ServerName="{0}"' -f $DatabaseServer
    $parameters += 'Database="{0}"' -f $DatabaseName
    $parameters += 'LogFile="{0}"' -f $NAVErrorLogFile

    if ($NAVServerName) {
      $parameters += 'NavServerName="{0}"' -f $NAVServerName
      $parameters += 'NavServerInstance="{0}"' -f $NAVServerInstance
      $parameters += 'NavServerManagementport={0}' -f $NAVServerManagementPort
    }
    
    if ($Username) {
      $parameters += 'NTAuthentication=0'
      $parameters += 'Username="{0}"' -f $Username
      $parameters += 'Password="{0}"' -f $Password
    }
    $parameterstring = $parameters -join ","
    
    Write-Verbose "Invoking $NAVIde with parameters:`n$parameterstring"
    Start-Process -FilePath $NAVIde -ArgumentList $parameterstring -Wait 

    $ErrorMessage = $ErrorText
    [bool]$ErrorRaised = $false
    if (Test-Path $CommandResultFile) {
      Remove-Item $CommandResultFile
      if (Test-Path $NAVErrorLogFile) {
        $ErrorContent = Get-Content $NAVErrorLogFile -Raw
        $ErrorContentFormatted = $ErrorContent -replace "`r[^`n]", "`r`n"
        $ErrorMessage = "{0}:`n{1}" -f $ErrorText, $ErrorContentFormatted
        Remove-Item $NAVErrorLogFile
        $ErrorRaised = $true 
      }
    }
    if($createdFolder) {
      Remove-Item -Recurse -Force -ErrorAction Ignore -Path $LogPath
    }
    if($ErrorRaised) {
      throw $ErrorMessage
    }
  }
}