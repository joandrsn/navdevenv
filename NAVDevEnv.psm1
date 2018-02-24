Write-Verbose "This psm1 is only supposed to be used for debugging."
Write-Verbose "The real one will be in the build output."

$folders = 'private', 'public'
foreach ($folder in $folders) {
  $folderpath = Join-Path $PSScriptRoot $folder
  if (Test-Path -Path $folderpath) {
    Write-Verbose "Processing folder $folderpath"
    $files = Get-ChildItem -Path $folderpath -Include "*.ps1" -Exclude "*.test.ps1" -Recurse
    foreach ($file in $files ) {
      $VerboseMsg = "Dot-sourcing " -f $file.FullName
      Write-Verbose $VerboseMsg
      . $file.FullName
    }
  }
}

$publicfolder = Join-Path $PSScriptRoot 'public'
$publicfunctions = Get-ChildItem $publicfolder -Filter "*.ps1"
foreach ($publicfunction in $publicfunctions) {
  Export-ModuleMember -Function $publicfunction.BaseName
}