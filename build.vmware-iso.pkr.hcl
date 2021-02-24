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
    iso_paths            = ["[${var.vsphere-datastore}] ${var.isopath-win2016}", "[] /vmimages/tools-isoimages/windows.iso"]
    vm_name              = var.win2016-template-name
  }
  source "source.vsphere-iso.base-windows" {
    name                 = "2019"
    floppy_files         = ["${path.root}/answer_files/windowsserver2019/autounattend.xml", "./scripts/windowsserver2019/set-ip.ps1", "./scripts/disable-screensaver.ps1", "./scripts/disable-winrm.ps1", "./scripts/enable-winrm.ps1", "./scripts/unattend.xml", "./scripts/sysprep.bat", "./scripts/install-vmwaretools.ps1", "./scripts/win-updates.ps1", "./scripts/win-updates2.ps1"]
    guest_os_type        = "windows9Server64Guest"
    iso_paths            = ["[${var.vsphere-datastore}] ${var.isopath-win2019}", "[] /vmimages/tools-isoimages/windows.iso"]
    vm_name              = var.win2019-template-name
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