<#
Creates a self signed certificate and imports it into you Persoanl and Root stores. 
I used this when setting up a new development site on dev machine.
#>



If(-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))
{
    #build up the deploy arguments
    $arguments = "-file `"{0}`"" -f $script:MyInvocation.MyCommand.Path
    
    # Start the new process
    Start-Process powershell.exe -Verb runas -ArgumentList $arguments
    exit
}
else
{
    $dnsName = Read-Host "Type the dns name for the cert"
    $dnsName = $dnsName
    $pfx = new-SelfSignedCertificate -DnsName $dnsName -CertStoreLocation cert:\LocalMachine\My
    $friendlyName = "SelfSigned-" + $dnsName
    $pfx.FriendlyName = $friendlyName    
    $store =  new-object System.Security.Cryptography.X509Certificates.X509Store(
        [System.Security.Cryptography.X509Certificates.StoreName]::Root,
        "localmachine"
    )
    $store.open("MaxAllowed") 
    $store.add($pfx) 
    $store.close()
    Write-Host "Your certificate has been added to the Personal and Root stores succesfully"
}

Read-Host "Press any key to exit"

