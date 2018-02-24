# NAVDevEnv module
### A module wrapper for finsql.exe
This module is intended for [Dynamics NAV](https://en.wikipedia.org/wiki/Microsoft_Dynamics_NAV) developers.

I didn't like the way the original finsql.exe

This module helps developers run powershell commands thorugh finsql.exe and do stuff with it.

A few advantages:
- No files left behind after command execution.
- Includes a `Start-NAVIde`-command for starting the development enviroment
- Generates a separate `.zup`-file for each unattended command run.
- Does not set `$NAVIDE`-variable which helps on enviroment with multiple versions installed.


### Installation
It exists on [PSGallery](https://www.powershellgallery.com/packages/NAVDevEnv) so installation should be as simple as running this command in PowerShell:
```
Install-Module -Name NAVDevEnv
```