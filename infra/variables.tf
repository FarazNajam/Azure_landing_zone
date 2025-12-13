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
}

variable "web_app_name" {
  type = string
}

variable "sku_name" {
  type    = string
  description = "Plan SKU (F1/B1/P1v3 etc.)"
}

variable "os_type" {
  type    = string
}

################################################################

variable "hub_virtual_network_name" {
  description = "Name of the hub VNet."
  type        = string
  default     = "vnet-hub-prod"
}

variable "hub_NSG_name" {
  description = "Name of the NSG associated with subnet1."
  type        = string
}

variable "hub_address_space" {
  type        = list(string)
}

variable "hub_subnets" {
  type = map(object({
    address_prefixes = list(string)
  }))
}

############################################################################
variable "app_spoke_virtual_network_name" {
  description = "Name of the hub VNet."
  type        = string
  default     = "vnet-app-spoke-prod"
}

variable "app_spoke_NSG_name" {
  description = "Name of the NSG associated with subnet1."
  type        = string
}

variable "app_spoke_address_space" {
  type        = list(string)
}

variable "app_spoke_subnets" {
  type = map(object({
    address_prefixes = list(string)
  }))
}


#############################################################################

##########################################################################
variable "data_spoke_virtual_network_name" {
  description = "Name of the hub VNet."
  type        = string
  default     = "vnet-hub-prod"
}

variable "data_spoke_NSG_name" {
  description = "Name of the NSG associated with subnet1."
  type        = string
}

variable "data_spoke_address_space" {
  type        = list(string)
}

variable "data_spoke_subnets" {
  type = map(object({
    address_prefixes = list(string)
  }))
}

########################################################################
variable "mgmt_spoke_virtual_network_name" {
  description = "Name of the hub VNet."
  type        = string
  default     = "vnet-mgmt-spoke-prod"
}

variable "mgmt_spoke_NSG_name" {
  description = "Name of the NSG associated with subnet1."
  type        = string
}

variable "mgmt_spoke_address_space" {
  type        = list(string)
}

variable "mgmt_spoke_subnets" {
  type = map(object({
    address_prefixes = list(string)
  }))
}


