output "vnet_id" {
  value       = azurerm_virtual_network.vnet.id
  description = "The ID of the virtual network"
}

output "subnet_ids" {
  value       = { for name, s in azurerm_subnet.subnets : name => s.id }
  description = "A map of subnet names to their IDs"
}
