# Terraform variables for this module (ensure you have these in variables.tf)
# variable "name" { type = string }
# variable "location" { type = string }
# variable "resource_group_name" { type = string }

# Redis Cache (Prod)
resource "azurerm_redis_cache" "redis" {
  name                = var.name     # e.g. "redis-prod"
  location            = var.location # e.g. "Canada Central"
  resource_group_name = var.resource_group_name

  sku_name            = "Basic"
  capacity            = 0
  family              = "C"
  minimum_tls_version = "1.2"

  redis_configuration {
    maxmemory_policy = "allkeys-lru"
  }

  tags = {
    environment = "prod"
  }
}
