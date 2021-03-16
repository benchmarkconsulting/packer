<!-- ABOUT THE PROJECT -->
## About The Project
This is an Image Creation as Code Project for Windows and RHEL images leveraging HashiCorp's Packer. Packer is an open source tool for creating identical machine images for multiple platforms from a single source configuration. Packer is lightweight, runs on every major operating system, and is highly performant, creating machine images for multiple platforms in parallel. Packer allows us to start with an ISO and end up with a hardened and patched VMWare template that can be provisioned with HashiCorp's Terraform.

Packer Benefits:
* Automated approach to image creation
* Images are continually secured: hardened at patched during creation
* Consistent method for creating consumable images
* Your time should be focused on creating something amazing. A project that solves a problem and helps others :smile:

You can suggest changes by forking this repo and creating a pull request or opening an issue.

A list of commonly used resources that we find helpful are listed in the Resources.

### Packer Builder from VMWare vSphere

At Univeris, Packer leverages the vSphere API to create VMware templates via code. These deployable VMWare templates start with a vendor approved ISO.  Packer then applies the desired configuration through supplied answer files. This result is a hardened, patched VMware template (golden image) that can be used to build server environments with Terraform.

# Packer Inputs

```
ISO RHEL/Windows
```
- Downloaded from vendor  
- Uploaded and stored in corresponding folder in vSphere.
```
Packer build HCL files
```
- Stored in Git

build.vmware-iso.pkr.hcl  
source.vmware-iso.pkr.hcl  
variables.common.pkr.hcl  
variables.x.pkr.hcl  (where 'x' is specific to the version of the OS that you are building)  
secret.auto.pkrvars.hcl  

```
Answer files

```
- Stored in Git

RHEL - Kickstart File  
Windows - Autounattend.xml File

### The Process

#### Download ISOs from Vendor

Download RHEL ISO from Red Hat or Windows ISO from Microsoft.

#### Upload ISOs to vSphere

Sign into the vSphere client 

Choose the **isos** folder.  
Choose the corresponding sub-folder for the type of ISO that you are uploading:

* Windows
* RHEL

Click **Upload Files**
Select the ISO you wish to upload

#### When updating ISOs

When you acquire a new ISO from a vendor, the variable in the corresponding variables file would need to be updated. For example, if Red Hat released an updated ISO to replace RHEL 8.3 with RHEL 8.4, you would update the **variables.rhel8.pkr.hcl** file with the updated ISO name and commit the change. For example, replace **rhel-8.3-x86_64-dvd.iso** with **rhel-8.4-x86_64-dvd.iso**

#### Building the Images

Start a Packer Build manually, or merge a change to one of the Packer Build HCLs Files. Packer initiates a VM on the host and starts the build process.

The Answer files contain answers to all questions normally asked during the OS installation. These files helps to automate the installation process, without need for any intervention from the user.  This includes hardening requirements to meet CIS Standards. When the build is complete, it is marked as a template in vSphere. This template is the considered to be the gold image.

<!-- GETTING STARTED -->
## Getting Started



### Prerequisites

Use yum-config-manager to add the official HashiCorp Linux repository.

* Packer
```
sudo yum install -y yum-utils
```
```
sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo
```
```
sudo yum -y install packer
```

* mkisofs (to support CD ISO Creation)
```
sudo yum -y install mkisofs
```

### Usage

1. Clone the repo
```
git clone https://github.com/benchmarkconsulting/packer.git
```
2. Change Directory
```
cd univeris/packer/vmware/x-hcl (replace 'x' with the OS that you are looking to build)
```

3. Add required secrets to the secret.auto.pkrvars.hcl file
```
vsphere-user = ""
vsphere-password = ""
ssh-username = "" (from the OS specific kickstart file)
ssh-password = "" (from the OS specific kickstart file)
```

4. Validate your changes
```
packer validate .
```

5. Build all images
```
packer build -force .
```

6. Build a specific image
```
packer build -force -only '*.x' .

(The -only switch enables you to isolate a specific source to build from.  Replace 'x' with the name of the source from the build file)
```

7. Example Output:
```
==> rhel.vsphere-iso.7: Creating CD disk...
    rhel.vsphere-iso.7: Warning: creating filesystem with Joliet extensions but without Rock Ridge
    rhel.vsphere-iso.7: extensions. It is highly recommended to add Rock Ridge.
    rhel.vsphere-iso.7: I: -input-charset not specified, using utf-8 (detected in locale settings)
    rhel.vsphere-iso.7: Total translation table size: 0
    rhel.vsphere-iso.7: Total rockridge attributes bytes: 0
    rhel.vsphere-iso.7: Total directory bytes: 0
    rhel.vsphere-iso.7: Path table size(bytes): 10
    rhel.vsphere-iso.7: Max brk space used 0
    rhel.vsphere-iso.7: 184 extents written (0 MB)
    rhel.vsphere-iso.7: Done copying paths from CD_dirs
==> rhel.vsphere-iso.7: Uploading packer545505393.iso to packer_cache/packer545505393.iso
==> rhel.vsphere-iso.7: the vm/template Univeris VMs/Templates/RHEL7-Template-HCL already exists, but deleting it due to -force flag
==> rhel.vsphere-iso.7: Creating VM...
==> rhel.vsphere-iso.7: Customizing hardware...
==> rhel.vsphere-iso.7: Mounting ISO images...
==> rhel.vsphere-iso.7: Adding configuration parameters...
==> rhel.vsphere-iso.7: Set boot order temporary...
==> rhel.vsphere-iso.7: Power on VM...
==> rhel.vsphere-iso.7: Waiting 10s for boot...
==> rhel.vsphere-iso.7: Typing boot command...
==> rhel.vsphere-iso.7: Waiting for IP...
==> rhel.vsphere-iso.7: IP address: *.*.*.80
==> rhel.vsphere-iso.7: Using ssh communicator to connect: 10.10.116.80
==> rhel.vsphere-iso.7: Waiting for SSH to become available...
==> rhel.vsphere-iso.7: Connected to SSH!
==> rhel.vsphere-iso.7: Shutting down VM...
==> rhel.vsphere-iso.7: Deleting Floppy drives...
==> rhel.vsphere-iso.7: Eject CD-ROM drives...
==> rhel.vsphere-iso.7: Convert VM into template...
==> rhel.vsphere-iso.7: Clear boot order...
Build 'rhel.vsphere-iso.7' finished after 12 minutes 58 seconds.
```

<!-- Repo Strcuture -->
## Repo Structure
```
vmware/                   # Cloud                      
   windows/               # Operating System
   rhel/
   templates.pkr.hcl      # Packer Templates
   variables.pkrvars.hcl  # here we assign variables to particular systems

   answer_files/          # OS Specific answerfile requirements
        ks.cfg            # Kickstart File
        autounattend.xml  # Autounattend.xml
   scripts/
      sysprep.bat         # sysprep for Windows 
```

_For more examples, please refer to the [Documentation](https://www.packer.io/docs)_


<!-- Tips and Tricks -->
## Tips and Tricks

See [Best Practices](https://www.packer.io/docs/templates) for a list of Best Pracices and Tips and Tricks.


<!-- CONTRIBUTING -->
## Contributing

Contributions are what make an open source community and such an amazing place to be learn, inspire, and create. Any contributions you make are **greatly appreciated**.

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request


<!-- LICENSE -->
## License

Distributed under the MIT License. See `LICENSE` for more information.


<!-- CONTACT -->
## Contact

Matt Cole - matt.cole@benchmarkcorp.com  
Jeremy Carson - jeremy.carson@benchmarkcorp.com  
Jon Sammut - jon.sammut@benchmarkcorp.com  
David Patrick - dave.patrick@benchmarkcorp.com  

<!-- Resource LINKS  -->
## Resources

[https://packer.io](https://www.packer.io/)