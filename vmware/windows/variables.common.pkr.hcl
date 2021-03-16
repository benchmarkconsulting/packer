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
}
variable "vsphere-user" {
  type    = string
  sensitive = true
}
variable "vsphere-cluster" {
  type    = string
}
variable "vsphere-folder" {
  type    = string
  default = "Templates"
}
variable "vsphere-network" {
  type    = string
}
variable "vsphere-password" {
  type    = string
  sensitive = true
}
variable "winrm-user" {
  type    = string
  sensitive = true
}
variable "winrm-password" {
  type    = string
  sensitive = true
}
variable "vsphere-datastore" {
  type    = string
}