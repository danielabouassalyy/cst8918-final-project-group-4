output "aks_cluster_name" {
  value     = azurerm_kubernetes_cluster.cluster.name
  sensitive = true
}

output "client_certificate" {
  value     = azurerm_kubernetes_cluster.cluster.kube_config[0].client_certificate
  sensitive = true
}

output "kube_config" {
  value     = azurerm_kubernetes_cluster.cluster.kube_config_raw
  sensitive = true
}