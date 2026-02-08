variable "subscription_id" {
  type = string
}

variable "resource_group_name" {
  type        = string
  description = "Existing RG to deploy into"
}

variable "location" {
  type        = string
  default     = "australiaeast"
  description = "Location; defaults to RG location if null"
}

variable "key_vault_name" {
  type    = string
  default = "KV-landingzone-prod-8531"
}

variable "web_app_name" {
  type = string
}

################################################################

variable "hub_virtual_network_name" {
  type        = string
  default     = "vnet-hub-prod"
  description = "Name of the hub VNet."
}

variable "hub_NSG_name" {
  type        = string
  description = "Name of the NSG associated with subnet1."
}

variable "hub_address_space" {
  type = list(string)
}

variable "hub_subnets" {
  type = map(object({
    address_prefixes = list(string)
  }))
}

############################################################################

variable "app_spoke_virtual_network_name" {
  type        = string
  default     = "vnet-app-spoke-prod"
  description = "Name of the app spoke VNet."
}

variable "app_spoke_NSG_name" {
  type        = string
  description = "Name of the NSG associated with subnet1."
}

variable "app_spoke_address_space" {
  type = list(string)
}

variable "app_spoke_subnets" {
  type = map(object({
    address_prefixes = list(string)
  }))
}

############################################################################

variable "data_spoke_virtual_network_name" {
  type        = string
  default     = "vnet-data-spoke-prod"
  description = "Name of the data spoke VNet."
}

variable "data_spoke_NSG_name" {
  type        = string
  description = "Name of the NSG associated with subnet1."
}

variable "data_spoke_address_space" {
  type = list(string)
}

variable "data_spoke_subnets" {
  type = map(object({
    address_prefixes = list(string)
  }))
}

########################################################################

variable "mgmt_spoke_virtual_network_name" {
  type        = string
  default     = "vnet-mgmt-spoke-prod"
  description = "Name of the mgmt spoke VNet."
}

variable "mgmt_spoke_NSG_name" {
  type        = string
  description = "Name of the NSG associated with subnet1."
}

variable "mgmt_spoke_address_space" {
  type = list(string)
}

variable "mgmt_spoke_subnets" {
  type = map(object({
    address_prefixes = list(string)
  }))
}

############################################

variable "vms" {
  description = "Map of VMs and their configuration"
  type = map(object({
    nic     = string
    VM_name = string
    VM_size = string
    subnet  = string
  }))
}

variable "vnets" {
  type = map(object({
    virtual_network_name = string
    NSG_name             = string
    address_space        = list(string)
    subnets = map(object({
      address_prefixes = list(string)
    }))
  }))
}

############################################

variable "key_vaults" {
  description = "A list of Key Vaults to be deployed"
  type = map(object({
    name                        = string
    enabled_for_disk_encryption = bool
    soft_delete_retention_days  = number
    purge_protection            = bool
  }))
}