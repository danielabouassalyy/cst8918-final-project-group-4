# outputs.tf (repo root)

# Test Redis (non-sensitive)
output "redis_test_hostname" {
  value       = module.redis_test.hostname
  description = "Test Redis hostname"
}

output "redis_test_ssl_port" {
  value       = module.redis_test.ssl_port
  description = "Test Redis SSL port"
}

# Prod Redis (non-sensitive)
output "redis_prod_hostname" {
  value       = module.redis_prod.hostname
  description = "Prod Redis hostname"
}

output "redis_prod_ssl_port" {
  value       = module.redis_prod.ssl_port
  description = "Prod Redis SSL port"
}

output "acr_name" { value = module.acr.name }
output "acr_login_server" { value = module.acr.login_server }
