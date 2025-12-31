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

#######################################################################################
# Data Spoke VNet

module "data_spoke_virtual_network" {
  source = "./modules/Network"

  virtual_network_name = var.data_spoke_virtual_network_name
  location             = var.location
  resource_group_name  = var.resource_group_name
  NSG_name             = var.data_spoke_NSG_name
  address_space        = var.data_spoke_address_space
  subnets              = var.data_spoke_subnets
}

#######################################################################################
# Mgmt Spoke VNet

module "mgmt_spoke_virtual_network" {
  source = "./modules/Network"

  virtual_network_name = var.mgmt_spoke_virtual_network_name
  location             = var.location
  resource_group_name  = var.resource_group_name
  NSG_name             = var.mgmt_spoke_NSG_name
  address_space        = var.mgmt_spoke_address_space
  subnets              = var.mgmt_spoke_subnets
}

#######################################################################################
locals {
  spokes = {
    app  = { vnet_id = module.app_spoke_virtual_network.vnet_id,  vnet_name = module.app_spoke_virtual_network.vnet_name,  rg = module.app_spoke_virtual_network.resource_group_name }
    data = { vnet_id = module.data_spoke_virtual_network.vnet_id, vnet_name = module.data_spoke_virtual_network.vnet_name, rg = module.data_spoke_virtual_network.resource_group_name }
    mgmt = { vnet_id = module.mgmt_spoke_virtual_network.vnet_id, vnet_name = module.mgmt_spoke_virtual_network.vnet_name, rg = module.mgmt_spoke_virtual_network.resource_group_name }
  }
}

module "peer_hub_to_spokes" {
  for_each = local.spokes
  source   = "./modules/Vnet_peering"

  name                      = "peer-hub-to-${each.key}-spoke"
  resource_group_name       = module.hub_virtual_network.resource_group_name
  virtual_network_name      = module.hub_virtual_network.vnet_name
  remote_virtual_network_id = each.value.vnet_id
}

module "peer_spokes_to_hub" {
  for_each = local.spokes
  source   = "./modules/Vnet_peering"

  name                      = "peer-${each.key}-spoke-to-hub"
  resource_group_name       = each.value.rg
  virtual_network_name      = each.value.vnet_name
  remote_virtual_network_id = module.hub_virtual_network.vnet_id
}


