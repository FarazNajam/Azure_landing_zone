variable "name" {
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

variable "tenant_id" {
  description = "Azure AD tenant ID for the Key Vault."
  type        = string
}
