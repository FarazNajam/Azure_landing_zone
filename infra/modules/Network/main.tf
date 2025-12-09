
resource "azurerm_network_security_group" "NSG_01" {
  name                = var.NSG_name
  location            = var.location
  resource_group_name = var.resource_group_name
}

resource "azurerm_virtual_network" "VNET01" {
  name                = var.virtual_network_name
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = var.address_space

  subnet {
    name             = var.subnet1
    address_prefixes = var.address_prefix
  }

  tags = {
    environment = "Production"
  }
}