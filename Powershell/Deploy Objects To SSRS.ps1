<#
Script for handling the deploying of rdls and other related reporting files to an ssrs server
#>


#Gets a list of all the reports and images that are in the folder the running script is in
function Get-Report-List
{
	#Grab all the reports in the folder that the running script is in
	$reports = Get-ChildItem $PSScriptRoot -Filter *.rdl
	
	#Grab all the images in the folder that the running script is in
	$images = Get-ChildItem $PSScriptRoot -Filter *.png

	$files = $reports + $images
	
	$files = $files | Select-Object -ExpandProperty FullName

	return $files
}

#Get a list of user selected files
function Get-User-Selected-Files
{
	[System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms") | Out-Null
	$objForm = New-Object System.Windows.Forms.OpenFileDialog
	$objForm.InitialDirectory = $PSScriptRoot
	$objForm.Filter = $Filter
	$objForm.Title = "Select files to deploy"
	$objForm.Multiselect = $true
	$Show = $objForm.ShowDialog()
	If ($Show -ne "OK")
	{
		Write-Error "Cancelled..."
		Read-Host "Press any key to close..." 
		Exit
	}
	$files = $objForm.FileNames
	Return $files
}


#Parses keys from the specified server list and returns the found values
function Parse-Server-List
(
	[Parameter(Position=0,Mandatory=$false)]
	[Alias("k")]
	[string[]]$keys,
	
	[Parameter(Position=1,Mandatory=$false)]
	[Alias("s")]
	[hashtable]$serverLookup
)
{   
	$matches = @()
	foreach ($key in $keys -split ",")
	{
		if($serverLookup.ContainsKey($key))
		{
			#multi select var
			if($key.Contains("a"))
			{
				$matches += Parse-Server-List -k $serverLookup.Item($key) -s $serverLookup
			}
			else
			{
				$matches += ,$serverLookup.Item($key)
			}
		}
	}
	return $matches
}

#Asks the user to select what servers to deploy and builds up an appropriate list
function Get-Server-List
{
	#fill in your server list.  
	# the q1\q2 | qa notation is used to handle environments that have multiple servers 
	#ie. q1 would be qa server 1 and q2 would be server 2 then when the script runs you can choose to deploy to a 
	#specif server or all servers in an environment
	$servers = @{
		"q1" = ""
		"q2" = ""
		
		"p1" = ""
		"p2" = ""
		"p3" = ""
		"p4" = ""
		"p5" = ""
		"p6" = ""
		"p7" = ""
		"p8" = ""
		"p9" = ""
		
		"pa" = "p1,p2,p3,p4,p5,p6,p7,p8,p9"
		"qa" = "q1,q2"
	}
	$selectedServers = ""
	#if the script was passed names then just display them
	if($Script:ServerNames)
	{
		$selectedServers = $Script:ServerNames -split ","
	}
	else
	{
		#Get servers wanted
		$getServerOutput = "`nPlease input the value corresponding the appropriate deployment selection.`nValues can be comma delimited (no space i.e. d1,q2,p3)...`n"
	
		$servers.GetEnumerator() | Sort-Object Name | % { $getServerOutput += "{0}: {1}`n" -f $_.Name, $_.Value }
	
		$serverKeys = Read-Host $getServerOutput"Input"
	 
		$selectedServers =Parse-Server-List -k $serverKeys -s $servers
	}
		
	Write-Host "`nServer List:"
	$selectedServers | % { Write-Host "$_" }
	return $selectedServers
}

#Starts the deploy process
function Start-Deploy
(
	[Parameter(Position=0,Mandatory=$true)]
	[Alias("sn")]
	[string[]]$serverNames,

	[Parameter(Position=1,Mandatory=$true)]
	[Alias("f")]
	[string[]]$files
)
{
	$persistUser = $true

	#Get User Authentication object
	if($serverNames.Count -gt 1)
	{
		$persistUserResp = Read-Host "Would you like to use the same username for each server (y/n)?"
		$persistUser = $persistUserResp.ToLower() -contains "y"
	}

	if($persistUser)
	{
		$user = Get-Credential
	}


	$fileBytesCollection = Get-File-Bytes -f $files

	#Enumerate all the reports and upload them to the server
	$jobs = New-Object System.Collections.ArrayList
	foreach($server in $serverNames)
	{
		if($persistUser -eq $false)
		{
			$user = Get-Credential
		}
        
        $status = "`nCreating deployment job for server {0}" -f $server
        Write-Host $status
		
        $job = Deploy-Reports -s $server -fbc $fileBytesCollection -u $user
		$jobs.Add($job) | Out-Null
        
        $status = "Job created successfully" -f $server
        Write-Host $status
	}
	
    Write-Host "Waiting until all jobs are finished..."

	while($jobs.Count -gt 0)
	{
		for($index = 0; $index -lt $jobs.Count; $index++)
		{  
			try 
			{
				$job = $jobs[$index];

				$progress = ($job | Get-Job).ChildJobs[0].Progress

				$activity =  ($progress.Activity, $progress.Activity[-1])[$progress.Activity.Count -gt 1]
			   
				$status =  ($progress.StatusDescription, $progress.StatusDescription[-1])[$progress.Activity.Count -gt 1]

				$pctComplete = $progress.PercentComplete[-1]

				write-progress -activity $activity -status $status -percentcomplete $pctComplete -Id $index

				if($job.State -eq "Completed" -or $job.State -eq "Failed") 
				{
					$job | Receive-Job
					$job | Stop-Job
					$job | Remove-Job 
					$jobs.Remove($job)
					$index --
				}
			}
			catch
			{
				Continue
			}
		}

		Start-Sleep -Seconds 0.5
	}
}

function Get-File-Bytes
(
	[Parameter(Position=0,Mandatory=$true)]
	[Alias("f")]
	[string[]]$files
)
{
	$fileBytesCollection = @{}
	$index = 0
	foreach($file in $files)
	{
		try
		{
			$index++

			#Get Report content in bytes
			$msg = "Getting file ({0}\{1}) content (byte) of {2}" -f $index, $files.Count, $file
			$msg | Write-Host

			
			$fullFilePath = $file
			if(!$file.Contains("\"))
			{
				$fullFilePath = "{0}\{1}" -f $PSScriptRoot, $file
			}

			$byteArray = [System.IO.File]::ReadAllBytes($fullFilePath)
			$msg = "Total length: {0}" -f $byteArray.Length
			$msg | Write-Host

			$fileName = $file
			if($fileName.Contains("\"))
			{
				$fileParts = $fileName.Split("\")
				$fileName = $fileParts[$fileParts.Length - 1]
		
			}
			
			$fileBytesCollection.Add($fileName, $byteArray)
		}
		catch [System.IO.IOException]
		{
			$msg = "Error while reading file : '{0}', Message: '{1}'" -f $file, $_.Exception.Message
			$msg | Write-Error
			
		}
	}
    
    return $fileBytesCollection
}


function Deploy-Reports
(
	[Parameter(Position=0,Mandatory=$true)]
	[Alias("s")]
	[string]$serverName,

	[Parameter(Position=1,Mandatory=$true)]
	[Alias("fbc")]
	[hashtable]$fileBytesCollection,

	[Parameter(Position=2,Mandatory=$true)]
	[Alias("u")]
	[PSCredential]$user
)
{

	$job = Start-Job -Name $serverName -ScriptBlock {
		
Add-Type -TypeDefinition @"
	public enum DeployStats
	{
		Success,
		Warning,
		Failure
	}
"@
		#installs a file on the reporting server
		function Install-File
		(
			[Parameter(Position=0,Mandatory=$true)]
			[Alias("f")]
			[string]$fileName,

			[Parameter(Position=1,Mandatory=$true)]
			[Alias("fb")]
			[byte[]]$fileBytes,
			
			[Parameter(Position=2,Mandatory=$true)]
			[Alias("rf")]
			[string]$reportFolder,

			[Parameter(Position=3,Mandatory=$true)]
			[Alias("p")]
			[Object]$ssrsProxy,

			[Parameter(Position=4,Mandatory=$true)]
			[Alias("a")]
			[Object]$activity,

			[Parameter(Position=5,Mandatory=$true)]
			[Alias("pct")]
			[int]$pctComplete
		)
		{
			$status = [DeployStats]::Success
			try
			{
			
				if($fileName.Contains(".rdl"))
				{
					$fileName = $fileName.Replace(".rdl","")
                    
                    #Remove report first, SSRS does not always honor the "overwrite" parameter for some reason...
                    $ssrsProxy.DeleteItem("$reportFolder/$fileName")
					#Call Proxy to upload report
					$warnings = $ssrsProxy.CreateReport($fileName,$reportFolder,$TRUE,$fileBytes,$null)
				}
				else
				{
                    #Remove report first, SSRS does not always honor the "overwrite" parameter for some reason...
                    $ssrsProxy.DeleteItem("$reportFolder/$fileName")
					#Call Proxy to upload image
					$warnings = $ssrsProxy.CreateResource($fileName,$reportFolder,$TRUE,$fileBytes,"image/png",$null)   
				}
		
				if($warnings.Length -ne $null -and $warning.Length -ne 0) 
				{ 
					$warnings | % {  Write-Warning "Warning: $_" }
					$deployStatus = [DeployStats]::Warning
				}
				else
				{
					$deployStatus = [DeployStats]::Success
				}
			}
			catch [System.IO.IOException]
			{
				$status = "Error while reading rdl file : '{0}', Message: '{1}'" -f $fileName, $_.Exception.Message
				Write-Progress -activity $activity -status $status  -percentcomplete $pctComplete
				$deployStatus = [DeployStats]::Failure
			}
			catch [System.Web.Services.Protocols.SoapException]
			{
				$status = "Error while uploading rdl file : '{0}', Message: '{1}'" -f $fileName, $_.Exception.Detail.InnerText
				Write-Progress -activity $activity -status $status  -percentcomplete $pctComplete
				$deployStatus = [DeployStats]::Failure
			}
			return $deployStatus
		}


        #since this code is executing inside a job the values of these variables have to
        #be set again.  Using the same name so that it doesnt look to confusing
        $serverName = $args[0] 
        $fileBytesCollection = $args[1]
        $user = $args[2]

        $activity = 'Initializing Job'
        Write-Progress -activity $activity -status 'Setting up deployment variables' -percentcomplete 0
				
		$SuccessCount = 0
		$WarningCount = 0
		$FailureCount = 0
		
		#set this to a specific folder if necessary
		$reportFolder = "/" 

		$totalReports = $fileBytesCollection.Count
        
		$stepCounter = 1
		$totalSteps = $totalReports + 1;      
        $pctComplete = ($stepCounter / $totalSteps) * 100   
   
        $progressStatement = "Total reports to deploy: {0}" -f $totalReports
        Write-Progress -activity $activity -status $progressStatement -percentcomplete $pctComplete

		$url = "https://{0}/ReportServer/ReportService2005.asmx" -f $serverName
		$progressStatement = "Setting deployment url to {0}" -f $url
        Write-Progress -activity $activity -status $progressStatement -percentcomplete $pctComplete

        $activity = 'Deploying files to {0}' -f $url	
		
		
		
		try
		{
            $progressStatement = "Setting up connection to server {0}" -f $url
            Write-Progress -activity $activity -status $progressStatement -percentcomplete $pctComplete
			$ssrsProxy = New-WebServiceProxy -Uri $url -Credential $user

            if($ssrsProxy -eq $null)
			{
				$msg = "Failed to connect to server"
				Write-Error $msg
				throw $msg
			}

			Write-Progress -activity $activity -status 'Finished setting up connection' -percentcomplete $pctComplete


			foreach($fileName in $fileBytesCollection.Keys)
			{   
                $stepCounter ++
				$pctComplete = ($stepCounter / $totalSteps) * 100
				
				$uploadStatement = "Uploading {0} to {1}" -f $fileName, $url
				Write-Progress -activity $activity -status $uploadStatement -percentcomplete $pctComplete
				$status = Install-File -f $fileName -fb $fileBytesCollection[$fileName] -rf $reportFolder -p $ssrsProxy -a $activity -pct $pctComplete
                
                $uploadStatement = "Finished uploading {0} to {1}" -f $fileName, $url
				Write-Progress -activity $activity -status 'Upload complete' -percentcomplete $pctComplete
				
                switch ($status)
				{
					Success 
					{
						$SuccessCount ++
					}
					Warning 
					{
						$WarningCount ++
					}
					Failure 
					{
						$FailureCount ++
					}
				}	
			}
		}
		finally
		{
			if($ssrsProxy -ne $null)
			{
				$ssrsProxy.Dispose()
			}
		}
		

		Write-Progress -activity $activity -status 'Deployment Complete' -percentcomplete 100
		"`nDeployment Results: {0}" -f $serverName | Write-Host -foregroundColor Green
		"Total Successes {0}:{1}" -f $SuccessCount, $totalReports | Write-Host -foregroundColor White 
		"Total Warnings {0}:{1}" -f $WarningCount, $totalReports | Write-Host -foregroundColor Yellow
		"Total Failures {0}:{1}" -f $FailureCount, $totalReports | Write-Host -foregroundColor Red 
	} -ArgumentList $serverName, $fileBytesCollection, $user

	return $job
}


function Select-Files
{
	$deployAll = Read-Host "Please select the number for your chosen deployment type`n1) Select files`n2) All files`nSelection"
	if($deployAll -eq "1")
	{
		$files = Get-User-Selected-Files
	}
	else
	{
		$files = Get-Report-List
	}
	
	Write-Host "Selected Files:"
	$files | % { Write-Host "$_" } 
	return $files  
}


$files = Select-Files

if($files -eq $null -or $files.Count -le 0)
{
	Write-Error "There are no files to deploy"	
	Read-Host "Press any key to exit"
	exit
}

$servers = Get-Server-List
if($servers -eq $null -or $servers.Count -le 0)
{
	Write-Error "There are no servers selected to deploy to"	
	Read-Host "Press any key to exit"
	exit
}




Start-Deploy -sn $servers -f $files

Read-Host "Press any key to exit"
