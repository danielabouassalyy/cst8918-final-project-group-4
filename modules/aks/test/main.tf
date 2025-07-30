resource "azurerm_resource_group" "cluster" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_log_analytics_workspace" "aks_logs" {
  name                = "aks-logs"
  location            = azurerm_resource_group.cluster.location
  resource_group_name = azurerm_resource_group.cluster.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

resource "azurerm_kubernetes_cluster" "cluster" {
  name                              = var.aks_cluster_name
  location                          = azurerm_resource_group.cluster.location
  resource_group_name               = azurerm_resource_group.cluster.name
  role_based_access_control_enabled = true
  dns_prefix                        = "leaks1"
  kubernetes_version                = 1.32

  default_node_pool {
    name           = "default"
    node_count     = 1
    vm_size        = "Standard_B2s"
    vnet_subnet_id = var.subnet_id
  }

  network_profile {
    network_plugin = "azure" # or "kubenet" depending on your setup
    network_policy = "azure" # or "calico"
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    Environment = "test"
  }

}

resource "azurerm_monitor_diagnostic_setting" "aks_diagnostics" {
  name                       = "aks-diagnostics"
  target_resource_id         = azurerm_kubernetes_cluster.cluster.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.aks_logs.id

  metric {
    category = "AllMetrics"
    enabled  = true

    retention_policy {
      enabled = false
      days    = 0
    }
  }
}