output "vnet_id" {
  value = azurerm_virtual_network.VNET01.id
}

output "vnet_name" {
  value = azurerm_virtual_network.VNET01.name
}

output "resource_group_name" {
  value = var.resource_group_name
}

output "subnet_ids" {
  description = "Map of subnet names to subnet IDs"
  value = {
    for k, s in azurerm_subnet.subnets :
    k => s.id
  }
}

