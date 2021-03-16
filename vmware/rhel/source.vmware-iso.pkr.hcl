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