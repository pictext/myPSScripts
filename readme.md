This sample creates an empty script file for implementing a Lambda function written
in PowerShell.

The script has a Requires statement for the latest version of the AWS Tools for
PowerShell module (AWSPowerShell.NetCore) as an example for how to declare modules on
which your function is dependent and that will be bundled with your function on
deployment. If you do not need to use cmdlets from this module you can safely delete
this statement.

Example:
Open Powershell Host > 6.0 and run the following commands
1)  Publish-AWSPowerShellLambda -ScriptPath RekognitionPSScript.ps1 -Name  RekognitionPSScript -Region us-east-1
2)  cd C:\Users\<user>\AppData\Local\Temp\RekognitionPSScript
3)  dotnet lambda package --output-package ./RekognitionPSScript.zip

Zip file is ready for upload through AWS Lambda console.