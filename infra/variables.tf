########################################
# Core / Subscription
########################################

variable "subscription_id" {
  description = "Azure subscription ID where resources will be deployed"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group for networking and core resources"
  type        = string
}

variable "web_app_name" {
  description = "Name of the web application"
  type        = string
}

variable "location" {
  description = "Azure region for resource deployment"
  type        = string
}

########################################
# Key Vault
########################################

variable "key_vault_name" {
  description = "Primary Key Vault name"
  type        = string
}

variable "key_vaults" {
  description = "Map of Key Vault configurations"
  type = map(object({
    name                        = string
    enabled_for_disk_encryption = bool
    soft_delete_retention_days  = number
    purge_protection            = bool
  }))
}

########################################
# Hub Virtual Network
########################################

variable "hub_virtual_network_name" {
  description = "Name of the hub virtual network"
  type        = string
}

variable "hub_NSG_name" {
  description = "Name of the NSG associated with the hub VNet"
  type        = string
}

variable "hub_address_space" {
  description = "Address space for the hub virtual network"
  type        = list(string)
}

variable "hub_subnets" {
  description = "Subnets within the hub virtual network"
  type = map(object({
    address_prefixes = list(string)
  }))
}

########################################
# App Spoke Virtual Network
########################################

variable "app_spoke_virtual_network_name" {
  description = "Name of the application spoke virtual network"
  type        = string
}

variable "app_spoke_NSG_name" {
  description = "Name of the NSG for the app spoke VNet"
  type        = string
}

variable "app_spoke_address_space" {
  description = "Address space for the app spoke VNet"
  type        = list(string)
}

variable "app_spoke_subnets" {
  description = "Subnets within the app spoke virtual network"
  type = map(object({
    address_prefixes = list(string)
  }))
}

########################################
# Data Spoke Virtual Network
########################################

variable "data_spoke_virtual_network_name" {
  description = "Name of the data spoke virtual network"
  type        = string
}

variable "data_spoke_NSG_name" {
  description = "Name of the NSG for the data spoke VNet"
  type        = string
}

variable "data_spoke_address_space" {
  description = "Address space for the data spoke VNet"
  type        = list(string)
}

variable "data_spoke_subnets" {
  description = "Subnets within the data spoke virtual network"
  type = map(object({
    address_prefixes = list(string)
  }))
}

########################################
# Management Spoke Virtual Network
########################################

variable "mgmt_spoke_virtual_network_name" {
  description = "Name of the management spoke virtual network"
  type        = string
}

variable "mgmt_spoke_NSG_name" {
  description = "Name of the NSG for the management spoke VNet"
  type        = string
}

variable "mgmt_spoke_address_space" {
  description = "Address space for the management spoke VNet"
  type        = list(string)
}

variable "mgmt_spoke_subnets" {
  description = "Subnets within the management spoke virtual network"
  type = map(object({
    address_prefixes = list(string)
  }))
}

########################################
# Virtual Machines
########################################

variable "vms" {
  description = "Map of virtual machine configurations"
  type = map(object({
    nic     = string
    VM_name = string
    VM_size = string
    subnet  = string
  }))
}

########################################
# Generic VNet Map (for loops / reuse)
########################################

variable "vnets" {
  description = "Generic map of VNets and their subnet definitions"
  type = map(object({
    virtual_network_name = string
    NSG_name             = string
    address_space        = list(string)

    subnets = map(object({
      address_prefixes = list(string)
    }))
  }))
}
