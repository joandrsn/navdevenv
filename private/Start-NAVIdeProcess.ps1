function Start-NAVIdeProcess {
  [CmdletBinding(DefaultParameterSetName = 'All')]
  Param(
    [Parameter(Mandatory)]
    [string] $Argument)
  Process {
    Write-Verbose "Invoking $NAVIde with parameters:`n$Argument"
    Start-Process -FilePath $NAVIde -ArgumentList $Argument -Wait 
  }
}