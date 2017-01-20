<#
This script is useful when you need to generate the host file ip resolutions for a list of servers. 
I have used this script in the past when debugging a multi tenant environment hosted in azure.  I had to 
simulate my box being on the local network and allowing server resolution based on box name and not the 
fqdn.
#>

$servers = @(
        #Comma delimitted list of servers to gen host file for
        )

Write-Host("#Server List")    
Foreach($server in $servers)
{
    $dnsObj = [System.Net.Dns]::GetHostByName($server)
    $ip = $dnsObj.AddressList | Select-Object -First 1
    $serverName = $server.Split(".") | Select-Object -First 1
    $ip.IPAddressToString + "`t" + $serverName | Write-Host
}

Read-Host("Press any key to exit...")
