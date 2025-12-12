
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
}

resource "azurerm_subnet" "subnets" {
  for_each             = var.subnets
  name                 = each.key
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.VNET01.name
  address_prefixes     = each.value.address_prefixes
}

  tags = {
    environment = "Production"
  }

