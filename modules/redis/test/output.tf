output "hostname" {
  value       = azurerm_redis_cache.redis.hostname
  description = "Redis hostname"
}

output "primary_access_key" {
  value       = azurerm_redis_cache.redis.primary_access_key
  sensitive   = true
  description = "Primary access key for Redis"
}