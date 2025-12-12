resource_group_name  ="rg-kv-dev-01"
web_app_name         ="web-homelab-dev"
location             ="australiaeast"
virtual_network_name ="vnet-dev-01-8531"                    # must be globally unique
NSG_name             ="NSG-dev-01-8531"
address_space        =["10.0.0.0/16"]

subnets = {
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

