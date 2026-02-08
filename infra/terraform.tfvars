subscription_id     = "553b9494-e357-471f-8b75-796409610ac1"
resource_group_name = "rg-vnet-hub-spoke-prod"
web_app_name        = "web-homelab-dev"

location = "eastus"

key_vaults = {
  key_vault_01 = {
    name                        = "key_vault_01"
    enabled_for_disk_encryption = false
    soft_delete_retention_days  = 7
    purge_protection            = false
  }

  key_vault_02 = {
    name                        = "key_vault_02"
    enabled_for_disk_encryption = false
    soft_delete_retention_days  = 7
    purge_protection            = false
  }
}

hub_virtual_network_name = "hub_virtual_network"
hub_NSG_name             = "hub-vnet-NSG-prod"
hub_address_space        = ["10.0.0.0/16"]

hub_subnets = {
  AzureFirewallSubnet = {
    address_prefixes = ["10.0.1.0/24"]
  }

  GatewaySubnet = {
    address_prefixes = ["10.0.10.0/27"]
  }
}
