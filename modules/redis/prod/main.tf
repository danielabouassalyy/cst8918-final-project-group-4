# Resource Group
resource "azurerm_resource_group" "rg" {
  name     = "example-redis-rg"
  location = "eastus"
}

# Redis Cache
resource "azurerm_redis_cache" "redis" {
  name                = "prod-redis-cache" # Must be globally unique
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  # SKU options: Basic, Standard, Premium
  sku_name = "Standard"
  capacity = 0
  family   = "C"

  minimum_tls_version = "1.2"

  tags = {
    environment = "prod"
  }
}