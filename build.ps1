function Set-Variables
{
  [CmdletBinding()]
  Param()
  Process
  {
    $script:ModuleName = "NAVDevEnv"
    $script:ModuleGuid = '26c93502-a9af-4242-8b10-dd1941b97f11' 
    $script:Author = 'Jonas Andersen'
    $script:ModuleVersion = '1.0.0.3'
    $script:Description = 'Wrapper for finsql.exe (Dynamics NAV Developer Enviroment)'
    $script:OutputFolder = Join-Path $PSScriptRoot "output"
    $script:OutputModuleFolder = Join-Path $OutputFolder $ModuleName
    $script:ManifestFileName = '{0}.psd1' -f $ModuleName
    $script:ModuleFileName = '{0}.psm1' -f $ModuleName
    $script:ModuleFile = Join-Path $OutputModuleFolder $ModuleFileName
    $script:ManifestFile = Join-Path $OutputModuleFolder $ManifestFileName
  }
}

function New-ModuleBuild
{
  [CmdletBinding()]
  Param()
  Process
  {
    [string[]]$FolderNames = "private", "public"
    [String[]]$ExportList = @()
    $sb = [System.Text.StringBuilder]::new()
    foreach($FolderName in $FolderNames)
    {
      $FolderPath = Join-Path $PSScriptRoot $FolderName
      $FolderContent = Get-ChildItem $FolderPath -Filter "*.ps1"
      foreach($File in $FolderContent) {
        $FileContent = Get-Content $File.FullName -Raw
        $VerboseMsg = 'Write-Verbose "Importing {0}"' -f $File.BaseName
        [void]$sb.AppendLine($VerboseMsg)
        [void]$sb.AppendLine()
        [void]$sb.AppendLine($FileContent)
        [void]$sb.AppendLine()

        if($FolderName -eq "public") {
          $ExportList += $File.BaseName
        }
      }
    }
    
    foreach($Item in $ExportList) {
      $ExportCmd = 'Export-ModuleMember -Function "{0}"' -f $Item
      [void]$sb.AppendLine($ExportCmd)
    }

    Out-File $ModuleFile -NoClobber -Encoding UTF8 -InputObject $sb.ToString() -NoNewline
    Write-Output $ExportList
  }
}

function Clear-Module
{
  [CmdletBinding()]
  Param()
  Process
  {
    if(Test-Path $OutputModuleFolder) {
      Remove-Item $OutputModuleFolder -Force -Recurse -ErrorAction Ignore
    }
    $null = New-Item -ItemType Directory -Path $OutputModuleFolder -Force
  }
}
function New-ModuleManifestBuild
{
  [CmdletBinding()]
  Param(
    [String[]] $Functions
    )
  Process
  {
    $Params = @{
      'Path' = $ManifestFile;
      'Guid' = $ModuleGuid;
      'Author' = $Author;
      'RootModule' = $ModuleFileName;
      'FunctionsToExport' = $Functions;
      'CmdletsToExport' = '';
      'VariablesToExport' = '';
      'AliasesToExport' = '';
      'ModuleVersion' = $ModuleVersion
      'Description' = $Description;
    }
    New-ModuleManifest @Params
  }
}

Set-Variables
Clear-Module
$ExportedFunctions = New-ModuleBuild
New-ModuleManifestBuild -Functions $ExportedFunctions