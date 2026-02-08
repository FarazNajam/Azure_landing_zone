variable "resource_group_name" {
  type        = string
  description = "Existing RG to deploy into"
}

variable "location" {
  type        = string
  description = "Location; defaults to RG location if null"
}

variable "nic" {
  type = string
}

variable "VM_name" {
  type = string
}

variable "VM_size" {
  type = string
}

variable "subnet_id" {
  type = string
}
