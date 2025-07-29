resource "azurerm_resource_group" "backend" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_storage_account" "backend" {
  name                     = var.storage_account_name
  resource_group_name      = azurerm_resource_group.backend.name
  location                 = azurerm_resource_group.backend.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  enable_https_traffic_only = true
  min_tls_version           = "TLS1_2"
}

resource "azurerm_storage_container" "backend" {
  name                  = var.container_name
  storage_account_name  = azurerm_storage_account.backend.name
  container_access_type = "private"
}
