# Backend: Azure Storage (remote state)
  backend "azurerm" {
    resource_group_name  = "rg-terraform-state-file-prod-01"
    storage_account_name = "terraformstatefileprod02"
    container_name       = "tfstate"
    key                  = "keyvault/dev.tfstate"

    # Use Entra ID + OIDC from GitHub
    use_azuread_auth = true
    use_oidc         = true
  }
}

provider "azurerm" {
  features {}
}

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

  name                = "kv-dev-01-8531"                      # must be globally unique
  location            = var.location
  resource_group_name = var.resource_group_name
  tenant_id           = data.azurerm_client_config.current.tenant_id
}

# Virtual Network Module
module "virtual_network" {
  source = "./modules/Network"

  virtual_network_name = var.virtual_network_name                      # must be globally unique
  location             = var.location
  resource_group_name  = var.resource_group_name
  NSG_name             = var.NSG_name
  address_space        = var.address_space
  address_prefix       = var.address_prefix
  subnet1              = var.subnet1
}
