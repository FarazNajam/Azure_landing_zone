# Get current tenant / object IDs (from the service principal)
data "azurerm_client_config" "current" {}

# Resource group (shared for this env)
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

# Key Vault module
module "key_vault" {
  source = "./modules/key_vault"

  name                = var.key_vault_name # must be globally unique
  location            = var.location
  resource_group_name = var.resource_group_name
  tenant_id           = data.azurerm_client_config.current.tenant_id
}

#######################################################################################
# Hub VNet (central)

module "hub_virtual_network" {
  source = "./modules/Network"

  virtual_network_name = var.hub_virtual_network_name
  location             = var.location
  resource_group_name  = var.resource_group_name
  NSG_name             = var.hub_NSG_name
  address_space        = var.hub_address_space
  subnets              = var.hub_subnets
}

#######################################################################################
# App Spoke VNet

module "app_spoke_virtual_network" {
  source = "./modules/Network"

  virtual_network_name = var.app_spoke_virtual_network_name
  location             = var.location
  resource_group_name  = var.resource_group_name
  NSG_name             = var.app_spoke_NSG_name
  address_space        = var.app_spoke_address_space
  subnets              = var.app_spoke_subnets
}
