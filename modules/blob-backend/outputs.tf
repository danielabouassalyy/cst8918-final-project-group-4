output "storage_account_id" {
  value       = azurerm_storage_account.backend.id
  description = "ID of the storage account"
}

output "container_name" {
  value       = azurerm_storage_container.backend.name
  description = "Name of the blob container"
}
