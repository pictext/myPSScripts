# PowerShell script file to be executed as a AWS Lambda function. 
# 
# When executing in Lambda the following variables will be predefined.
#   $LambdaInput - A PSObject that contains the Lambda function input data.
#   $LambdaContext - An Amazon.Lambda.Core.ILambdaContext object that contains information about the currently running Lambda environment.
#
# The last item in the PowerShell pipeline will be returned as the result of the Lambda function.
#
# To include PowerShell modules with your Lambda function, like the AWSPowerShell.NetCore module, add a "#Requires" statement 
# indicating the module and version.

#Requires -Modules @{ModuleName='AWSPowerShell.NetCore';ModuleVersion='3.3.553.0'}
# Uncomment to send the input event to CloudWatch Logs

$BucketName = $LambdaInput.bucketname
$Client = new-object System.Net.WebClient
Try
{
    if($LambdaInput.s3key)
    {
        $FileName = $LambdaInput.s3key
    }
    else
    {
        $Url = $LambdaInput.url
        $Arr = $Url.Split('/')
        $FileName = $Arr[$Arr.Length-1]
        $TempFolder = "/tmp/$FileName"
        $Client.DownloadFile($Url,$TempFolder)
        Write-S3Object -BucketName $BucketName -File $TempFolder 
    }   
}
Catch
{
    $ErrorMessage = $_.Exception.Message
    $FailedItem = $_.Exception.ItemName
    Write-Host "Failed to upload invoice. $FailedItem. The error message was $ErrorMessage"
    Write-Host (ConvertTo-Json -InputObject $LambdaInput -Compress -Depth 5)
    Break
}
Write-Host (ConvertTo-Json -InputObject $LambdaInput -Compress -Depth 5)
$Blocks = Find-REKText  -ImageBucket  $BucketName  -ImageName $FileName
ConvertTo-Json -InputObject $Blocks -Compress -Depth 5
