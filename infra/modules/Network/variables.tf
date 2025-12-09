variable "virtual_network_name" {
  description = "Name of the Key Vault (must be globally unique)."
  type        = string
}

variable "location" {
  description = "Azure region for the Key Vault."
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group where the Key Vault will be created."
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

