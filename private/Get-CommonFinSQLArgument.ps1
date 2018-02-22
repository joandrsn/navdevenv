function Get-CommonFinSQLArgument {
  [CmdletBinding()]
  Param(
    [string[]] $CommandList,
    [string] $DatabaseServer,
    [Parameter(Mandatory)]
    [string] $DatabaseName,
    [string] $Username,
    [string] $Password,
    [string] $ErrorLogFile,
    [string] $NavServerName,
    [string] $NavServerInstance,
    [int16]  $NavServerManagementPort = 7045)

  Process {
    $parameters = @()
    if ($CommandList) {
      $parameters += $CommandList
    }
    $parameters += 'ServerName="{0}"' -f $DatabaseServer
    $parameters += 'Database="{0}"' -f $DatabaseName
    $parameters += 'ID="{0}"' -f $DatabaseName

    if ($CommandList) {
      $parameters += 'LogFile="{0}"' -f $ErrorLogFile
    }

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
    Write-Output $parameterstring
  }
}