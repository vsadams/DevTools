<#
TFS specific script to merge two shelvesets...might be outdated...made this a long time ago.
#>

function Get-Workspace
{
    $workspaces = @{
        #"1" = "Workspace1"
        #"2" = "Workspace2"
    }

    $workspacesOutput = "`nPlease select a workspace...`n"
    $workspaces.GetEnumerator() | Sort-Object Name | % { $workspacesOutput += "{0}: {1}`n" -f $_.Name, $_.Value }
    
    $workspaceKey = Read-Host $workspacesOutput"Input"
    
    if($workspaces.Contains($workspaceKey))
    {
        $workspaceName =$workspaces.Item($workspaceKey)
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

$workspace = Get-Workspace
$vsDevCmdLoc="C:\Program Files (x86)\Microsoft Visual Studio 12.0\Common7\Tools\VsDevCmd.bat"

$fromBranch = Read-Host "`nFrom Branch"
$targetBranch = Read-Host "`nTarget Brach"
$changeSetName= Read-Host "`nShelveset Name"


Start-Process $vsDevCmdLoc


$filePath=#"C:\PATH_TO_SOURCE" -f $workspace

CD $filePath


$unshelveCmd = "`"{0}`" /migrate /source:`"#$/SOURCE_CODE`" /target:`"#$/SOURCE_CODE`"" -f $changeSetName, $fromBranch, $targetBranch
tfpt unshelve $unshelveCmd
