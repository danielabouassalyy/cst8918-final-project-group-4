output "acr_login_server" {
  value       = azurerm_container_registry.acr.login_server
  description = "Login server for the ACR (for Docker pushes)"
}

output "app_load_balancer_ip" {
  value       = kubernetes_service.app.status[0].load_balancer[0].ingress[0].ip
  description = "Public IP address for the weather-app service"
}
