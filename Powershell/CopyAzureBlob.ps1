
### Source VHD (West US) - authenticated container ###
$srcUri = "https://xxx.blob.core.windows.net/vhds/yyy.vhd" 
 
### Source Storage Account (West US) ###
$srcStorageAccount = "srcAcct"
$srcStorageKey = "keySrc"
 
### Target Storage Account (West US) ###
$destStorageAccount = "destAcct"
$destStorageKey = "keyDest"
 
### Create the source storage account context ### 
$srcContext = New-AzureStorageContext  –StorageAccountName $srcStorageAccount `
                                        -StorageAccountKey $srcStorageKey  
 
### Create the destination storage account context ### 
$destContext = New-AzureStorageContext  –StorageAccountName $destStorageAccount `
                                        -StorageAccountKey $destStorageKey  
 
### Create the container on the destination ### 
#New-AzureStorageContainer -Name $containerName -Context $destContext 
 
### Start the asynchronous copy - specify the source authentication with -SrcContext ### 
$blob1 = Start-AzureStorageBlobCopy -srcUri $srcUri `
                                    -SrcContext $srcContext `
                                    -DestContainer "destContainer" `
                                    -DestBlob "destBlob.vhd" `
                                    -DestContext $destContext

$status = $blob1 | Get-AzureStorageBlobCopyState 
 
### Print out status ### 
$status 
 
### Loop until complete ###                                    
While($status.Status -eq "Pending"){
  $status = $blob1 | Get-AzureStorageBlobCopyState 
  Start-Sleep 10
  ### Print out status ###
  $status
}