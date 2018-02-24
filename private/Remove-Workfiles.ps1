function Remove-Workfiles
{
  [CmdletBinding()]
  Param(
    [Parameter(Mandatory)]
    [PSCustomObject] $Variables
  )
  Process
  {
    if ($Variables.CreatedFolder) {
      Remove-Item -Recurse -ErrorAction Ignore -Path $Variables.LogPath
    } else {
      Remove-Item -Path $Variables.ErrorLogFile -ErrorAction Ignore
      Remove-Item -Path $Variables.CommandResultFile -ErrorAction Ignore
    }
    Remove-Item -Path $Variables.ID -ErrorAction Ignore
  }
}