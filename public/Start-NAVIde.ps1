function Start-NAVIde {
  [CmdletBinding(DefaultParameterSetName = 'All')]
  Param(
    [Parameter()]
    [String]$DatabaseServer = ".",
    [Parameter(Mandatory)]
    [String]$DatabaseName,
    [Parameter(ParameterSetName = 'UsernamePassword', Mandatory)]
    [String]$DatabaseUsername,
    [Parameter(ParameterSetName = 'UsernamePassword', Mandatory)]
    [String]$DatabasePassword
  )

  Test-NavIde

  if (-not ([System.Management.Automation.PSTypeName]'WindowsUITricks').Type)
  {
    Add-Type -TypeDefinition @"
    using System;
    using System.Runtime.InteropServices;
    public class WindowsUITricks {
      [DllImport("user32.dll")]
      [return: MarshalAs(UnmanagedType.Bool)]
      public static extern bool ShowWindowAsync(IntPtr hWnd, int nCmdShow);
    }
"@ -Debug:$false
  }

  #Show running window if available.
  $process = Get-Process | Where-Object {$PSItem.Path -eq $NAVIDE}
  if ($process) {
    [void] [WindowsUITricks]::ShowWindowAsync($process.MainWindowHandle, 2)
    [void] [WindowsUITricks]::ShowWindowAsync($process.MainWindowHandle, 10)
    return
  }

  $Argument = Get-CommonFinSQLArgument -DatabaseServer $DatabaseServer `
    -DatabaseName $DatabaseName `
    -Username $DatabaseUsername `
    -Password $DatabasePassword

  Start-Process -FilePath $NAVIde -ArgumentList $Argument
}