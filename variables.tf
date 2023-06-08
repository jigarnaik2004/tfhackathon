variable "rg_name" {
  type = string
}

variable "location" {
  type = string
}

variable "sa_name" {
  type = string
}

variable "geoRedundancy" {
  type = bool
}

variable "scontainer_name"{
   type = string
}
variable "scontainer_prefix"{
   type = string
   default = "containerprefix"
}
variable "scontainer_suffixlist"{
   type = list
}