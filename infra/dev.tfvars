resource_group_name  ="rg-kv-dev-01"
web_app_name         ="web-homelab-dev"
location             ="australiaeast"
hub_virtual_network_name ="hub_virtual_network"                    # must be globally unique
hub_NSG_name             ="NSG-dev-01-8531"
hub_address_space        =["10.1.0.0/16"]
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
  "snet-shared-services" = {        # key has a hyphen, so quote it
    address_prefixes = ["10.0.30.0/24"]
  }
}
################################################################################################################
app_spoke_virtual_network_name ="app_spoke_virtual_network"                    # must be globally unique
app_spoke_NSG_name             ="NSG-dev-01-8531"
app_spoke_address_space        =["10.1.0.0/16"]
app_spoke_subnets = {
  snet_web = {
    address_prefixes = ["10.1.1.0/24"]
  }
  snet-app = {
    address_prefixes = ["10.1.2.0/24"]
  }
}

################################################################################################################
data_spoke_virtual_network_name ="app_spoke_virtual_network"                    # must be globally unique
data_spoke_NSG_name             ="NSG-dev-01-8531"
data_spoke_address_space        =["10.2.0.0/16"]
data_spoke_subnets = {
  snet_db = {
    address_prefixes = ["10.2.1.0/24"]
  }
}

################################################################################################################
mgmt_spoke_virtual_network_name ="app_spoke_virtual_network"                    # must be globally unique
mgmt_spoke_NSG_name             ="NSG-dev-01-8531"
mgmt_spoke_address_space        =["10.3.0.0/16"]
mgmt_spoke_subnets = {
  snet_db = {
    address_prefixes = ["10.3.1.0/24"]
  }
}

