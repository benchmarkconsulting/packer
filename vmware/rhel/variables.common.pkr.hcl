variable "vm-cpu-num" {
  type    = string
  default = "2"
}

variable "vm-mem-size" {
  type    = string
  default = "4096"
}

variable "vm-disk-size" {
  type    = string
  default = "32768"
}

variable "vsphere-server" {
  type    = string
  default = ""
}

variable "vsphere-user" {
  type    = string
  default = ""
  sensitive = true
}

variable "vsphere-cluster" {
  type    = string
  default = "Flexpod"
}

variable "vsphere-folder" {
  type    = string
  default = ""
}

variable "vsphere-network" {
  type    = string
  default = ""
}

variable "vsphere-password" {
  type    = string
  default = ""
  sensitive = true
}

variable "ssh-password" {
  type    = string
  default = ""
  sensitive = true
}

variable "ssh-username" {
  type    = string
  default = ""
  sensitive = true
}

variable "vsphere-datastore" {
  type    = string
  default = ""
}