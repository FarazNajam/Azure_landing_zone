# Get current tenant / object IDs (from the service principal)
data "azurerm_client_config" "current" {}

# Example resource group for the Key Vault
# (You can rename this to whatever convention you like)
resource "azurerm_resource_group" "rg_kv" {
  name     = var.resource_group_name
  location = "australiaeast"
}
#
# Key Vault module
module "key_vault" {
  source = "./modules/key_vault"

  name                = "kv-dev-01-8531" # must be globally unique
  location            = var.location
  resource_group_name = var.resource_group_name
  tenant_id           = data.azurerm_client_config.current.tenant_id
}

#######################################################################################

module "app_spoke_virtual_network" {
  source = "./modules/Network"

  virtual_network_name = var.hub_virtual_network_name
  location             = var.location
  resource_group_name  = var.resource_group_name
  NSG_name             = var.hub_NSG_name
  address_space        = var.hub_address_space
  subnets              = var.hub_subnets
}

#########################################################################################

module "virtual_network" {
  source = "./modules/Network"

  virtual_network_name = var.app_spoke_virtual_network_name
  location             = var.location
  resource_group_name  = var.resource_group_name
  NSG_name             = var.app_spoke_NSG_name
  address_space        = var.app_spoke_address_space
  subnets              = var.app_spoke_subnets
}

####################################################################################
