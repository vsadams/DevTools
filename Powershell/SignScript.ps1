<#
This script will handle the signing of another script.  This is useful when trying to run powershell scripts
on a machine with higher secrurity.
#>

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



Force-Admin

$scriptToSign = Read-Host "Type the full pathname to the script that you want signed"
Write-Host "Signing your script" -ForegroundColor Green
$certArray = @(Get-ChildItem cert:\CurrentUser\My -codesign)
if($certArray.count -eq 0)
{
    Write-Host "Could not find a valid signing certification in the user store" -ForegroundColor Red
}
Set-AuthenticodeSignature $scriptToSign $certArray[0]

Write-Host "All Done" -ForegroundColor Green
Read-Host "Press any key to continue..."
