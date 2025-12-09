data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "this" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  tenant_id           = data.azurerm_client_config.current.tenant_id

  sku_name = "standard"

  # Use RBAC instead of access policies (recommended modern approach)
  enable_rbac_authorization = true

  # For now allow public network access (you can lock this down later
  # with VNet rules / private endpoints, especially if you use self-hosted runners).
  public_network_access_enabled = true

  # Reasonable defaults for lab use
  soft_delete_retention_days = 7
  purge_protection_enabled   = true
}
