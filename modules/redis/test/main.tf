resource "azurerm_redis_cache" "redis" {
  name                = var.name     # set to "cst8918-redis-0tnji9"
  location            = var.location # set to "Canada East"
  resource_group_name = var.resource_group_name

  sku_name                      = "Basic"
  family                        = "C"
  capacity                      = 0 # C0 == 0
  minimum_tls_version           = "1.2"
  non_ssl_port_enabled          = false
  public_network_access_enabled = true

  redis_configuration {
    maxmemory_policy = "allkeys-lru"
  }

  tags = {
    environment = "test"
  }
}
