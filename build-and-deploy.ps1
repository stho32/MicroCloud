<#

    This file is intended to be used on a micro cloud development system 
    which has all dependend projects checked out.

    It will build the api as well as create zip packages which may then be 
    uploaded to a location on the internet, where your microcloud instances
    can see and automatically react on the update.

#>
$msbuild = "C:\Program Files (x86)\Microsoft Visual Studio\2019\Professional\MSBuild\Current\Bin\MSBuild.exe"

Push-Location "C:\Projects\MicroCloudApi\Source\MicroCloud.API"

nuget restore MicroCloud.API.sln
&$msbuild /t:Clean,Build /p:Configuration=Release /p:Platform="Any CPU"
&$msbuild /p:DeployOnBuild=true /p:PublishProfile=FolderProfile

Remove-Item C:\Deployment\MicroCloud.API.ClientSide\Web.config
Remove-Item C:\Deployment\MicroCloud.API.CloudSide\Web.config

if (Test-Path "C:\Deployment\MicroCloud.API.ClientSide.zip") {
    Remove-Item "C:\Deployment\*.zip" -Force
}

Compress-Archive -Path C:\Deployment\MicroCloud.API.ClientSide\ -DestinationPath C:\Deployment\MicroCloud.API.ClientSide.zip
Compress-Archive -Path C:\Deployment\MicroCloud.API.CloudSide\ -DestinationPath C:\Deployment\MicroCloud.API.CloudSide.zip
Compress-Archive -Path C:\Projects\MicroCloud\Database\ -DestinationPath C:\Deployment\Database.zip

Pop-Location

Write-Host "Deployment packages are complete. You can find them in the directory C:\Deployment . Copy those zip files somewhere where your instances can get to." -ForegroundColor Green