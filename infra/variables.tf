variable "resource_group_name" {
  type = string
  description = "Existing RG to deploy into"
}

variable "location" {
  type        = string
  default     = "australiaeast"
  description = "Location; defaults to RG location if null"
}

variable "name_prefix" {
  type = string
  default = "homelab-commerce-mvp"
}

variable "web_app_name" {
  type = string
}

variable "sku_name" {
  type    = string
  default = "B1"
  description = "Plan SKU (F1/B1/P1v3 etc.)"
}

variable "os_type" {
  type    = string
  default = "Linux" # or "Windows"
}

variable "virtual_network_name" {
  description = "Name of the Key Vault (must be globally unique)."
  type        = string
}

variable "NSG_name" {
  description = "Name of the NSG associated with subnet1."
  type        = string
}

variable "subnet1" {
  description = "Name of subnet1."
  type        = string
}

variable "address_space" {
  description = "Namae of the resource group where the Key Vault will be created."
  type        = list(string)
}

variable "address_prefix" {
  description = "Name of the resource group where the Key Vault will be created."
  type        = list(string)
}

