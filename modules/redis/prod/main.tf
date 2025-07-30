# Resource Group
resource "azurerm_resource_group" "rg" {
  name     = "example-redis-rg"
  location = "eastus"
}

# Redis Cache
resource "azurerm_redis_cache" "redis" {
  name                = var.name # Must be globally unique
  location            = var.location
  resource_group_name = var.resource_group_name

  # SKU options: Basic, Standard, Premium
  sku_name            = "Basic"
  capacity            = 1
  family              = "C"
  minimum_tls_version = "1.2"
  redis_configuration {
    maxmemory_policy = "allkeys-lru"
  }

  tags = {
    environment = "prod"
  }
}