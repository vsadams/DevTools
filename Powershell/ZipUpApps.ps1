<#
Simple zip utility
#>

#Starts up a new powershell script in admin mode and deploys based on the specified params
function Force-Admin
{
    $wid=[System.Security.Principal.WindowsIdentity]::GetCurrent()
    $prp=new-object System.Security.Principal.WindowsPrincipal($wid)
    $adm=[System.Security.Principal.WindowsBuiltInRole]::Administrator
    $IsAdmin=$prp.IsInRole($adm)

    if (-Not $IsAdmin)
    {
        $arguments = "-file `"{0}`"" -f $script:MyInvocation.MyCommand.Path
        Start-Process powershell.exe -Verb runas -ArgumentList $arguments
        Exit
    }
    # Start the new process
    
}
function Zip-Processor
(
    [System.String] $sourceDir,
    [System.String] $zipFile
)
{
    #remove the old zip file if it exists
    "`nChecking if the destination zip at " + $zipFile + " exists" | Write-Host -ForegroundColor Green
    if(Test-Path $zipFile)
    {
        Write-Host "Deleting the destination zip file" -ForegroundColor Green
        Remove-Item $zipFile 
        Write-Host "Removal successful" -ForegroundColor Green
    }
    else
    {
        Write-Host "Zip does not exist" -ForegroundColor Green
    }
    
    
    #zip the files needed
    "`nZipping up the source dir at " + $sourceDir | Write-Host -ForegroundColor Green
    [Reflection.Assembly]::LoadWithPartialName("System.IO.Compression.FileSystem")
    $compressionLevel = [System.IO.Compression.CompressionLevel]::Optimal
    [System.IO.Compression.ZipFile]::CreateFromDirectory($sourceDir, $zipFile , $compressionLevel, $false) | Out-Null
    Write-Host "Zip successful" -ForegroundColor Green


    Write-Host 'Deleting configs from zip' -ForegroundColor Green
    $stream = New-Object IO.FileStream($zipfile, [IO.FileMode]::Open)
    $mode   = [IO.Compression.ZipArchiveMode]::Update
    $zip    = New-Object IO.Compression.ZipArchive($stream, $mode)

    ($zip.Entries | ? {$_.Name -like "*.config" -or $_.Name -like "*.vshost*"}) | % { $_.Delete() }

    $zip.Dispose()
    $stream.Close()
    $stream.Dispose()

    Write-Host "Deletion successful" -ForegroundColor Green
}

Force-Admin
$source = $PSScriptRoot + #"\PATH\XXX"
$zip = $PSScriptRoot + #"\XXX.zip"


#zip up the source code
Zip-Processor $source $zip

Read-Host "`nAll done..."
