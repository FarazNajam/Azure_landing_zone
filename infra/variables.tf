subscription_id     = "553b9494-e357-471f-8b75-796409610ac1"
resource_group_name = "rg-vnet-hub-spoke-prod"
web_app_name        = "web-homelab-dev"



################################################################################################################
key_vaults = {
  "key_vault_01" = {
    name                        = "key_vault_01"
    enabled_for_disk_encryption = false
    soft_delete_retention_days  = 7
    purge_protection            = false
  }

  "key_vault_02" = {
    name                        = "key_vault_02"
    enabled_for_disk_encryption = false
    soft_delete_retention_days  = 7
    purge_protection            = false
  }
}


key_vault_name           = "KV-landingzone-prod-8533"
location                 = "eastus"
hub_virtual_network_name = "hub_virtual_network" # must be globally unique
hub_NSG_name             = "hub-vnet-NSG-prod"
hub_address_space        = ["10.0.0.0/16"]
hub_subnets = {
  AzureFirewallSubnet = {
    address_prefixes = ["10.0.1.0/24"]
  }
  AzureFirewallManagementSubnet = {
    address_prefixes = ["10.0.2.0/24"]
  }
  GatewaySubnet = {
    address_prefixes = ["10.0.10.0/27"]
  }
  AzureBastionSubnet = {
    address_prefixes = ["10.0.20.0/27"]
  }
  "snet-shared-services" = { # key has a hyphen, so quote it
    address_prefixes = ["10.0.30.0/24"]
  }
}
################################################################################################################
app_spoke_virtual_network_name = "app_spoke_virtual_network" # must be globally unique
app_spoke_NSG_name             = "app-spoke-vnet-NSG-prod"
app_spoke_address_space        = ["10.1.0.0/16"]
app_spoke_subnets = {
  snet_web = {
    address_prefixes = ["10.1.1.0/24"]
  }
  snet-app = {
    address_prefixes = ["10.1.2.0/24"]
  }
}

################################################################################################################
data_spoke_virtual_network_name = "data_spoke_virtual_network" # must be globally unique
data_spoke_NSG_name             = "data-spoke-vnet-NSG-prod"
data_spoke_address_space        = ["10.2.0.0/16"]
data_spoke_subnets = {
  snet_data = {
    address_prefixes = ["10.2.1.0/24"]
  }
}

################################################################################################################
mgmt_spoke_virtual_network_name = "mgmt_spoke_virtual_network" # must be globally unique
mgmt_spoke_NSG_name             = "mgmt-spoke-vnet-NSG-prod"
mgmt_spoke_address_space        = ["10.3.0.0/16"]
mgmt_spoke_subnets = {
  snet_mgmt = {
    address_prefixes = ["10.3.1.0/24"]
  }
}

################################################################################################################
vms = {
  "app-spoke-vm-01" = {
    nic     = "nic-app-01"
    VM_name = "app-spoke-vm-01"
    VM_size = "Standard_D2as_v5"
    subnet  = "snet-app"
  }
}

################################################################################################################
vnets = {
  mgmt-spoke = {
    virtual_network_name = "mgmt_spoke_virtual_network"
    NSG_name             = "mgmt-spoke-NSG-01"
    address_space        = ["10.3.0.0/16"]

    subnets = {
      snet_mgmt = {
        address_prefixes = ["10.3.1.0/24"]
      }
    }
  }

  app-spoke = {
    virtual_network_name = "app_spoke_virtual_network"
    NSG_name             = "app-spoke-NSG-01"
    address_space        = ["10.1.0.0/16"]

    subnets = {
      snet-app = {
        address_prefixes = ["10.1.2.0/24"]
      }
      snet_web = {
        address_prefixes = ["10.1.1.0/24"]
      }
    }
  }

  data-spoke = {
    virtual_network_name = "data_spoke_virtual_network"
    NSG_name             = "data-spoke-NSG-01"
    address_space        = ["10.2.0.0/16"]

    subnets = {
      snet-app = {
        address_prefixes = ["10.2.1.0/24"]
      }
    }
  }
}
