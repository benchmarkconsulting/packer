# Packer build for Windows based Images on VMware
This Build handles the creation and configuration of Windows 2019 & 2016 based images in VMware.
The Build handles the following components: 
- Creation of VMWare Template
- Hardening Based on CIS Framework

## Compatibility
This packer config is meant for use with packer 1.7. 
## Usage
Usage is as follows:
Build File:
```hcl
build {
  name = "windows"
  description = <<EOF
//This build creates Windows images for the following versions :
* Windows Server 2016
* Windows Server 2019
For the following builders :
* vsphere-iso
EOF
  source "source.vsphere-iso.base-windows" {
    name                 = "2016"
    floppy_files         = ["${path.root}/answer_files/windowsserver2016/autounattend.xml", "./scripts/windowsserver2016/set-ip.ps1", "./scripts/disable-screensaver.ps1", "./scripts/disable-winrm.ps1", "./scripts/enable-winrm.ps1", "./scripts/unattend.xml", "./scripts/sysprep.bat", "./scripts/install-vmwaretools.ps1", "./scripts/win-updates.ps1", "./scripts/win-updates2.ps1"]
    guest_os_type        = "windows9Server64Guest"
    iso_paths            = ["[datastore] ISOs/windowsserver2016.iso", "[] /vmimages/tools-isoimages/windows.iso"]
    vm_name              = "Win-2016-Template"
  }
  source "source.vsphere-iso.base-windows" {
    name                 = "2019"
    floppy_files         = ["${path.root}/answer_files/windowsserver2019/autounattend.xml", "./scripts/windowsserver2019/set-ip.ps1", "./scripts/disable-screensaver.ps1", "./scripts/disable-winrm.ps1", "./scripts/enable-winrm.ps1", "./scripts/unattend.xml", "./scripts/sysprep.bat", "./scripts/install-vmwaretools.ps1", "./scripts/win-updates.ps1", "./scripts/win-updates2.ps1"]
    guest_os_type        = "windows9Server64Guest"
    iso_paths            = ["[datastore] ISOs/windowsserver2019.iso", "[] /vmimages/tools-isoimages/windows.iso"]
    vm_name              = "Win-2019-Template"
  }

  provisioner "powershell" {
    scripts = ["scripts/Install-Nuget.ps1", "scripts/win-updates.ps1"]
  }
  provisioner "windows-restart" {
    restart_timeout = "1h5m"
  }
  provisioner "powershell" {
    scripts = ["scripts/win-updates.ps1"]
  }
  provisioner "windows-restart" {
    restart_timeout = "1h5m"
  }
  provisioner "powershell" {
    scripts = ["scripts/win-updates.ps1"]
  }
  provisioner "windows-restart" {
    restart_timeout = "1h5m"
  }
  provisioner "powershell" {
    scripts = ["scripts/start_sleep.ps1", "scripts/win_hardening.ps1", "scripts/Remove-UpdateCache.ps1", "scripts/Reset-EmptySpace.ps1"]
  }
  provisioner "windows-restart" {
    restart_timeout = "1h5m"
  }
}
```
Source File:
```hcl
source "vsphere-iso" "base-windows" {
  cluster              = var.vsphere-cluster
  communicator         = "winrm"
  convert_to_template  = false
  CPUs                 = var.vm-cpu-num
  datastore            = var.vsphere-datastore
  disk_controller_type = ["nvme"]
  folder               = "Templates"
  insecure_connection  = true
  network_adapters {
    network      = var.vsphere-network
    network_card = "vmxnet3"
  }
  notes           = "Build via Packer"
  password        = var.vsphere-password
  RAM             = var.vm-mem-size
  RAM_reserve_all = false
  remove_cdrom    = false
  storage {
    disk_size             = var.vm-disk-size
    disk_thin_provisioned = true
  }
  username       = var.vsphere-user
  vcenter_server = var.vsphere-server
  winrm_password = var.winrm-password
  winrm_username = var.winrm-user
}
```

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