describe 'NAVDevEnv module tests' {

  BeforeAll {
    $ParentDir = Split-Path $PSScriptRoot
    $EntryPoint = Join-Path $ParentDir "Entrypoint.ps1"
    . $EntryPoint

    $runningIdes = Get-Process -Name "finsql" -ErrorAction Ignore
    if($runningIdes) {
      Write-Warning "Found running finsql.exe. Killing..."
      foreach($runningIde in $runningIdes) {
        $null = $runningIde.CloseMainWindow()
      }
    }
    function Get-TempCodeunitObject {
      Param($FileName, $ObjectDatabase)
      $ID = Get-Random -Minimum 50000 -Maximum 100000
      $Name = $(New-Guid).Guid.Replace("-", "").Substring(0, 20)
      $object = "OBJECT Codeunit $ID $Name`n {`n  OBJECT-PROPERTIES`n {`n    Date=; `n    Time=; `n    Version List=; `n  }`n  PROPERTIES`n {`n    OnRun=BEGIN`n            MESSAGE('hello world'); `n          END; `n`n  }`n  CODE`n {`n`n    BEGIN`n    END.`n  }`n}`n`n"
      $FilterText = "ID={0};Type=5" -f $ID
      $Query = "SELECT * FROM [{0}].dbo.[Object] WHERE [ID] = {1} AND [Type] = 5" -f $ObjectDatabase, $ID
      $object | Out-File $FileName -Encoding oem
      [PSCustomObject]@{
        ID         = $ID
        Name       = $Name
        Object     = $Object
        Query      = $Query
        File       = Resolve-Path $FileName
        FilterText = $FilterText
      }
    }
  }

  AfterAll {
    Get-Process -Name "finsql" -ErrorAction Ignore | Stop-Process -ErrorAction Ignore
  }

  it "Can create nav databases" {
    $NewDatabaseName = "pester-test-db"
    $SelectStmt = "SELECT * FROM sys.databases WHERE [name] = '{0}'" -f $NewDatabaseName
    $DropStmt = "IF EXISTS({0}) DROP DATABASE [{1}]" -f $SelectStmt, $NewDatabaseName
    Invoke-Sqlcmd -Query $DropStmt
    New-NAVDatabase -DatabaseName $NewDatabaseName
    $result = Invoke-Sqlcmd -Query $SelectStmt
    $result | Should Not BeNullOrEmpty
    Invoke-Sqlcmd -Query $DropStmt
  }

  it "Can import/remove nav object" {
    $importobject = Get-TempCodeunitObject -FileName "importobject.txt" -ObjectDatabase $Database
    try {
      Invoke-Sqlcmd -Query $importobject.Query | Should BeNullOrEmpty
      Import-NAVApplicationObject -DatabaseName $Database -Path $importobject.File -ImportAction Overwrite -SynchronizeSchemaChanges No
      Invoke-Sqlcmd -Query $importobject.Query | Should Not BeNullOrEmpty
      Remove-NAVApplicationObject -DatabaseName $Database -Filter $importobject.FilterText -SynchronizeSchemaChanges No -Confirm:$false
      Invoke-Sqlcmd -Query $importobject.Query | Should BeNullOrEmpty
    }
    finally {
      Remove-Item $importobject.File -ErrorAction Ignore
    }
  }

  it "Can compile nav object" {
    $importobject = Get-TempCodeunitObject -FileName "compileobject.txt" -ObjectDatabase $Database
    try {
      Invoke-Sqlcmd -Query $importobject.Query | Should BeNullOrEmpty
      Import-NAVApplicationObject -DatabaseName $Database -Path $importobject.File -ImportAction Overwrite -SynchronizeSchemaChanges No
      $beforeCompile = Invoke-Sqlcmd -Query $importobject.Query
      $beforeCompile.Compiled | Should be $false
      Start-CompileNAVApplicationObject -DatabaseName $Database -Filter $importobject.FilterText -SynchronizeSchemaChanges No
      $afterCompile = Invoke-Sqlcmd -Query $importobject.Query
      $afterCompile.Compiled | Should be $true
    }
    finally {
      Remove-NAVApplicationObject -DatabaseName $Database -Filter $importobject.FilterText -SynchronizeSchemaChanges No -Confirm:$false -ErrorAction Ignore
      Remove-Item $importobject.File -ErrorAction Ignore
    }
  }

  it "Can export nav object" {
    $importobject = Get-TempCodeunitObject -FileName "exportobject.txt" -ObjectDatabase $Database
    $exportfile = "exportobject2.txt"
    try {
      Remove-Item $exportfile -ErrorAction Ignore
      Invoke-Sqlcmd -Query $importobject.Query | Should BeNullOrEmpty
      Import-NAVApplicationObject -DatabaseName $Database -Path $importobject.File -ImportAction Overwrite -SynchronizeSchemaChanges No
      Invoke-Sqlcmd -Query $importobject.Query | Should Not BeNullOrEmpty
      Test-Path $exportfile | Should Be $false
      Export-NAVApplicationObject -DatabaseName $Database -Filter $importobject.FilterText -Path $exportfile
      Test-Path $exportfile | Should Be $true
    }
    finally {
      Remove-NAVApplicationObject -DatabaseName $Database -Filter $importobject.FilterText -SynchronizeSchemaChanges No -Confirm:$false -ErrorAction Ignore
      Remove-Item $importobject.File -ErrorAction Ignore
      Remove-Item $exportfile -ErrorAction Ignore
    }
  }

  it "Start NAVIde" {
    Start-NAVIde -DatabaseName $Database
    $result = Get-Process -Name "finsql"
    $result | Should Not BeNullOrEmpty
  }
}