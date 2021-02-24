# Packer build for Windows based Images on VMware
This Build handles the creation and configuration of Windows 2019 & 2016 based images in VMware.
The Build handles the following components: 
- Creation of VMWare Template
- Hardening Based on CIS Framework

## Compatibility
This packer config is meant for use with packer 1.7. 
## Usage
Usage is as follows:
1. git clone https://github.com/benchmarkconsulting/packer.git
2. Default passwords have not been provided in the code.  There are 3 places in each autounattend.xml file (2016/2019) that need to be updated. Located at `answer_files/<OS>/autounattend.xml` file. Simply search the file for the following terms and add a password between the <Value></Value> tags.
    1. AutoLogon > Password
    2. UserAccounts > AdministratorPassword
    3. UserAccounts > LocalAccount > Password 
```
<UserAccounts>
  <AdministratorPassword>
      <Value>myS3cretP@ssword</Value>
```
3. If using Static IPs update the IP address, MaskBits, Gateway, and DNS information in each script file (2016/2019). 
  Located at `scripts/<os>/set-ip.ps1`.
4. If using DHCP remove the SynchronousCommand block # 15 as shown below:
```
<SynchronousCommand wcm:action="add">
    <CommandLine>C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -File a:\set-ip.ps1</CommandLine>
    <Order>15</Order>
    <Description>set ip</Description>
</SynchronousCommand>
```
5. Update the dev.auto.pkrvars.hcl to match your environment.

<!-- Command Section -->
Then perform the following commands on the root folder:
- `packer validate .` to lint the template
- `packer build .` to start the template creation

<!-- BEGINNING OF Packer DOCS -->
## Common Inputs
| Name | Description | Type | Default | Sensitive |
|------|-------------|------|---------|:--------:|
| vm-cpu-num | Number of VCPU used to build the template.| `string` | `2` | no |
| vm-mem-size | The Amount of Memory to builf the template. | `string` | `4096` | no |
| vm-disk-size | The Default Disk size when building the template. | `string` | `32768` | no |
| vsphere-server |  The DNS or IP address of the VSphere Server. | `string` | `x.x.x.x` | no |
| vsphere-user | The user name to use to authenticate against the vCenter Server. | `string` | `""` | yes |
| vsphere-cluster | The VSphere Cluster to Launch the template on. | `string` | `""` | no |
| vsphere-folder | The Folder in VCenter to store the template in. | `string` | `Templates` | no |
| vsphere-network | The VLAN Network to launch the VM on to create the template. | `string` | `""` | no |
| vsphere-password | The Password for authenticating against VSphere. | `string` | `""` | yes |
| winrm-user | The WINRM user that is used to connect to the VM to run autounattend features. | `string` | `""`| yes |
| winrm-password | The WINRM password that is used to connect to the VM to run autounattend features. | `string` | `""` | yes |
| vsphere-datastore | The DataStore to store the VMware Template on. | `string` | `""` | no |

## Version Specific
| Name | Description | Type | Default | Sensitive |
|------|-------------|------|---------|:--------:|
| isoname-win2016 | OS Major Version of win2016. | `string` | `""` | no |
| isoname-win2019 | OS Major Version of win2019. | `string` | `""` | no |


<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements
Before this module can be used on a project, you must ensure that the following pre-requisites are fulfilled:
1. Packer is [installed](#software-dependencies) on the machine where Packer is executed.
2. The Service Account you execute the build with has the right [permissions](#VCenter-Service-Account-Requirements).
### Software Dependencies
#### Packer
- [Packer](https://www.packer.io/downloads) 1.7.0
### VCenter Service Account Requirements 
In order to execute this build you must have a Service Account with the
following VCenter permissions:
#### VM folder (this object and children):
- Virtual machine -> Inventory
- Virtual machine -> Configuration
- Virtual machine -> Interaction
- Virtual machine -> Snapshot management
- Virtual machine -> Provisioning
#### Resource pool, host, or cluster (this object):
- Resource -> Assign virtual machine to resource pool
#### Host in clusters without DRS (this object):
- Read-only
#### Datastore (this object):
- Datastore -> Allocate space
- Datastore -> Browse datastore
- Datastore -> Low level file operations
#### Network (this object):
- Network -> Assign network
#### Distributed switch (this object):
- Read-only
#### Datacenter (this object):
- Datastore -> Low level file operations
#### Host (this object):
Host -> Configuration -> System Management