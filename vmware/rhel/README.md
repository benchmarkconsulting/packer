# Packer build for RHEL 7/8 on VMware
This Build handles the creation and configuration of RHEL 7/8 based images in VMware.
The Build handles the following components: 
- Creation of VMWare Template
- Hardening Based on CIS Framework
- OpenSCAP Results of Template

## Compatibility
This packer config is meant for use with packer 1.7. 
## Usage
Usage is as follows:
Build File:
```hcl
build {
  name = "rhel"
  description = <<EOF
//This build creates RHEL images for the following versions :
* 7
* 8
For the following builders :
* vsphere-iso
EOF

  source "source.vsphere-iso.base-rhel" {
    name                 = "8"
    boot_command         = ["<tab><wait>", " inst.text inst.ks=cdrom:/dev/sr1:/ks8.cfg<enter>"]
    cd_files             = ["${path.root}/kickstart/ks8.cfg"]
    guest_os_type        = "rhel8_64Guest"
    iso_paths            = ["[${var.vsphere-datastore}] isos/${var.isoname-rhel8}"]
    vm_name              = "RHEL8-Template-HCL"
  }

  source "source.vsphere-iso.base-rhel" {
    name                 = "7"
    boot_command         = ["<tab><wait>", " inst.text inst.ks=cdrom:/dev/sr1:/ks7.cfg<enter>"]
    cd_files             = ["${path.root}/kickstart/ks7.cfg"]
    guest_os_type        = "rhel7_64Guest"
    iso_paths            = ["[${var.vsphere-datastore}] isos/${var.isoname-rhel7}"]
    vm_name              = "RHEL7-Template-HCL"
  }
}
```
Source File
```hcl
source "vsphere-iso" "base-rhel" {
  CPUs                 = var.vm-cpu-num
  RAM                  = var.vm-mem-size
  RAM_reserve_all      = false
  cluster              = var.vsphere-cluster
  convert_to_template  = true
  datastore            = var.vsphere-datastore
  disk_controller_type = ["pvscsi"]
  folder               = var.vsphere-folder
  insecure_connection  = "true"
  
  network_adapters {
    network      = var.vsphere-network
    network_card = "vmxnet3"
  }
  
  notes        = "Build via Packer"
  password     = var.vsphere-password
  ssh_password = var.ssh-password
  ssh_username = var.ssh-username
  
  storage {
    disk_size             = var.vm-disk-size
    disk_thin_provisioned = true
  }
  
  username       = var.vsphere-user
  vcenter_server = var.vsphere-server
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
| vm-mem-size | The Amount of Memory to build the template. | `string` | `4096` | no |
| vm-disk-size | The Default Disk size when building the template. | `string` | `32768` | no |
| vsphere-server |  The DNS or IP address of the VSphere Server. | `string` | `` | no |
| vsphere-user | The user name to use to authenticate against the vCenter Server. | `string` | `""` | yes |
| vsphere-cluster | The VSphere Cluster to Launch the template on. | `string` | `Flexpod` | no |
| vsphere-folder | The Folder in VCenter to store the template in. | `string` | `VMs/Templates` | no |
| vsphere-network | The VLAN Network to launch the VM on to create the template. | `string` | `` | no |
| vsphere-password | The Password for authenticating against VSphere. | `string` | `""` | yes |
| ssh-password | The Password used by the provisioner to connect to the VM. | `string` | `""`| yes |
| ssh-username | The Username used by SSH to connect to the VM. | `string` | `""` | yes |
| vsphere-datastore | The DataStore to store the VMware Template on. | `string` | `` | no |

## Version Specific
| Name | Description | Type | Default | Sensitive |
|------|-------------|------|---------|:--------:|
| isoname-rhel7 | OS Major Version of RHEL 7. | `string` | `rhel-server-7.9-x86_64-dvd.iso` | no |
| isoname-rhel8 | OS Major Version of RHEL 8. | `string` | `rhel-8.3-x86_64-dvd.iso` | no |


<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements
Before this module can be used on a project, you must ensure that the following pre-requisites are fulfilled:
1. Packer and mkisofs are [installed](#software-dependencies) on the machine where apcker is executed.
2. The Service Account you execute the build with has the right [permissions](#configure-a-service-account).
### Software Dependencies
#### mkisofs
- [mkisofs](../../README.md) 1.1.x
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