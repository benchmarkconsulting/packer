source "vsphere-iso" "base-windows" {
  cluster              = var.vsphere-cluster
  communicator         = "winrm"
  convert_to_template  = false
  CPUs                 = var.vm-cpu-num
  datastore            = var.vsphere-datastore
  disk_controller_type = ["nvme"]
  folder               = var.vsphere-folder
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
