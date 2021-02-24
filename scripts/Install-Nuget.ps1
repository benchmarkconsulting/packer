# install the nuget provider
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Install-PackageProvider -name nuget -Force
#add the PSgallery if it does not exist.
$Check = Get-PSRepository
if ($check.name -eq "PSGallery") {
    Write-Host "PSGallery is configured, moving on..."
}
Else {
    Register-PSRepository -Default -InstallationPolicy Trusted
}
Write-Host "Installing DSC Modules"
Write-Host "Installing AuditPolicyDSC"
Install-Module -Name AuditPolicyDsc -Force
Write-Host "Installing SecurityPolicyDsc"
Install-Module -Name SecurityPolicyDsc -Force
Write-Host "Installing NetworkingDsc"
Install-Module -Name NetworkingDsc -Force
Write-Host "Installing PSDesiredStateConfiguration"
Install-Module -Name xPSDesiredStateConfiguration -Force