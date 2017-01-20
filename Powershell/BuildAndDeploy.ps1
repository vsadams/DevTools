
<#
This script will build a project and attempt to do a deployment to a server. It will handle zipping in order to make the
copy and deployment a bit faster.  It will also swap in and out the AppOffline.htm 

It might be highly customized to the scenario for which I built it.  Take a good read through before using.

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

#Cycles through the listed workspaces and has a user select one
function Get-Workspace
{
    $workspaces = @{ 
        #list of repo folder names i.e "1" = "MyCoolRepo" "2" = "CopyOfCoolRepo"
        
    }

    $workspacesOutput = "`nPlease select a workspace...`n"
    $workspaces.GetEnumerator() | Sort-Object Name | % { $workspacesOutput += "{0}: {1}`n" -f $_.Name, $_.Value }
    
    $workspaceKey = Read-Host $workspacesOutput"Input"
    
    if($workspaces.Contains($workspaceKey))
    {
        $workspaceName = $workspaces.Item($workspaceKey)
        return $workspaceName
    }
    if($workspaces.Values.Contains($workspaceKey))
    {
        $workspaceName = $workspaceKey
        return $workspaceName
    }
    
    Write-Host "Invalid workspace selection`n"
    Get-Workspace
    
    
}

Force-Admin



$msbuildCmd = #msbuild directory...default.."C:\Windows\Microsoft.NET\Framework64\v4.0.30319\MSBuild.exe"
$msbuildCmd += #" xxx.csproj"

#modify if the configuration for your release is different
$msbuildCmd +=" /p:DeployOnBuild=true /p:PublishProfile=Local /p:VisualStudioVersion=12.0 /p:Configuration=Release /p:Platform=x86"
$msbuildCmd +=" /verbosity:q"

$zipFileName = #"xxx.zip"
$sourceSiteFolder = #"XXX"
$sourceSiteDir = #"C:\xxx\{0}" -f $sourceSiteFolder
$sourceZipPath =  "{0}\{1}" -f $PSScriptRoot, $zipFileName

$targetMachine = #"yyy"
$destinationSiteFolder = #"ZZZ"
$destinateDir = #"\\{0}\c$\XXX" -f $targetMachine
$destinationZipDir = "{0}\{1}" -f $destinateDir, $zipFileName
$destinationSiteDir = "{0}\{1}" -f $destinateDir, $destinationSiteFolder

#Set The console to a bigger window
$console = $host.UI.RawUI
$buffer = $console.BufferSize
$buffer.Width = 200
$buffer.Height = 2000
$console.BufferSize = $buffer
$size = $console.WindowSize
$size.Width = 200
$console.WindowSize = $size

$workspacePath = Get-Workspace



$filePath=  #"C:\ABC" -f $workspacePath

Write-Host "`nChecking if the source site directory exists" -ForegroundColor Green
if(Test-Path $sourceSiteDir)
{
	Write-Host "Source site directory does exists" -ForegroundColor Green
	
    Write-Host "`nRemoving all the files from the source site" -ForegroundColor Green
    Remove-Item -Recurse -Force $sourceSiteDir
    Write-Host "Removed all the files succesfully" -ForegroundColor Green
}
else
{
    Write-Host "The source directory for the site does not exist. Creating it now" -ForegroundColor Green 
    New-Item -ItemType directory -Path $sourceSiteDir | Out-Null
}

CD $filePath
Write-Host "`nBuilding and publishing website to local box" -ForegroundColor Green

Invoke-Expression $msbuildCmd


Write-Host "`nChecking if the build and publish was successful" -ForegroundColor Green
$appOfflineFile = #"{0}\ZZZ.htm" -f $sourceSiteDir
if(Test-Path $appOfflineFile)
{
    Write-Host "Build and local publish was successful"    
}
else
{
    Read-Host "Build or publish failed. Press any key to exit.." 
    Exit
}



#remove all the configs from the local site folder if the local site folder exists
Write-Host "`nRemoving all the configs from the source site" -ForegroundColor Green
$sourceSiteRemove = $sourceSiteDir + "\*.config" 
Remove-Item  $sourceSiteRemove -Force
Write-Host "Removed all the configs successfully" -ForegroundColor Green



#remove the old zip file if it exists
Write-Host "`nChecking if the source zip file exists" -ForegroundColor Green
if(Test-Path $sourceZipPath)
{
    Write-Host "Deleting the source zip file" -ForegroundColor Green
    Remove-Item $sourceZipPath 
    Write-Host "Removal successful" -ForegroundColor Green
}


#zip the files needed
Write-Host "`nZipping up the source site" -ForegroundColor Green
[Reflection.Assembly]::LoadWithPartialName("System.IO.Compression.FileSystem")
$compressionLevel = [System.IO.Compression.CompressionLevel]::Optimal
[System.IO.Compression.ZipFile]::CreateFromDirectory($sourceSiteDir, $sourceZipPath , $compressionLevel, $false) | Out-Null
Write-Host "Zip successful" -ForegroundColor Green


#Check and create directory for destination zip
Write-Host "`nChecking if destination zip directory exists" -ForegroundColor Green
if(-Not (Test-Path $destinateDir))
{
    Write-Host "`nCreating Directory for destination zip" -ForegroundColor Green
    New-Item -Item -Path $destinateDir -Type directory | Out-Null
}

#copy the zip to qa
Write-Host "`nCopying the source zip to the destination server" -ForegroundColor Green
Copy-Item -Path $sourceZipPath -Destination $destinationZipDir
Write-Host "Copy successful" -ForegroundColor Green


#Check and create directory for destination site
Write-Host "`nChecking if the destination site exists" -ForegroundColor Green
if(-Not (Test-Path $destinationSiteDir))
{
    Write-Host "`nCreating directory for destination site" -ForegroundColor Green
    New-Item -Path $destinationSiteDir -Type directory | Out-Null
}

#Copying the App_Offline.htm to server
Write-Host "`nCopying App_Offline To QA" -ForegroundColor Green
$sourceAppOffline_htm = "{0}\External\App_Offline.htm" -f $sourceSiteDir
Copy-Item -Path $sourceAppOffline_htm  -Destination $destinationSiteDir
Write-Host "Copy successful" -ForegroundColor Green

#Remove all root files except for bin and configs
Write-Host "`nRemoving all root files except for bin and configs on the destination site" -ForegroundColor Green
$destinationSiteRemove = "{0}\" -f $destinationSiteDir 
Get-ChildItem $destinationSiteRemove -Recurse | where {$_.FullName -notlike '*\bin*' -and $_.Name -ne 'App_Offline.htm' -and $_.Name -notlike '*.config'} | Remove-Item -Recurse -Force
Write-Host "Removal successful" -ForegroundColor Green



#remove all but the configs from server
Write-Host "`nRemoving all files except for configs on the destination site" -ForegroundColor Green
$destinationSiteRemove = "{0}\" -f $destinationSiteDir 
Get-ChildItem $destinationSiteRemove -Recurse | where {$_.Name -ne 'App_Offline.htm' -and $_.Name -notlike '*.config'} | Remove-Item -Recurse -Force
Write-Host "Removal successful" -ForegroundColor Green


#Extract the folder to the site folder on server
Write-Host "`nExtracting the destination zip to the destination site" -ForegroundColor Green
[System.IO.Compression.ZipFile]::ExtractToDirectory($destinationZipDir, $destinationSiteDir)
Write-Host "Extraction successful" -ForegroundColor Green


#Remove the App_Offline.htm
Write-Host "`nRemoving App_Offline.htm"
$destinationAppOffline_htm = "{0}\App_Offline.htm" -f $destinationSiteDir
Remove-Item $destinationAppOffline_htm
Write-Host "Removal Successful" -ForegroundColor Green


Read-Host "`nAll done, dont forget to do reports! Press any key to exit..."
