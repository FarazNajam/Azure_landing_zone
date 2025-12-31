output "vnet_id" {
  value = azurerm_virtual_network.VNET01.id
}

output "vnet_name" {
  value = azurerm_virtual_network.VNET01.name
}

output "resource_group_name" {
  value = var.resource_group_name
}
