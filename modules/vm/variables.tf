variable "image_name" {
  type    = string
  default = "0001-com-ubuntu-server-jammy"
}
variable "vm_name" {
  type    = string
  default = "team2vm"
}

variable "user_name" {
  type    = string
  default = "azureuser"
}

variable "vnname" {
  type    = string
  default = "team2vnet"
}

variable "subnetid" {
  type    = string
  default = "team2Subnet"
}

variable "public_key" {
  type = string

}
variable "rg_name" {
  type = string
}

variable "location" {
  type = string
}
