# Log Analytics Workspace
resource "azurerm_log_analytics_workspace" "aks_logs" {
  name                = "${var.aks_cluster_name}-logs"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

# AKS Prod Cluster
resource "azurerm_kubernetes_cluster" "cluster" {
  dns_prefix = var.aks_cluster_name
  name                = var.aks_cluster_name
  location            = var.location
  resource_group_name = var.resource_group_name
  kubernetes_version  = "1.32"

  default_node_pool {
    name           = "default"
  
    min_count           = 1
    max_count           = 3
    type           = "VirtualMachineScaleSets"
    vm_size        = "Standard_B2s"
    vnet_subnet_id = var.subnet_id
  }

  network_profile {
    network_plugin    = "azure"
    network_policy    = "azure"
    load_balancer_sku = "standard"
    outbound_type     = "loadBalancer"
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    Environment = "Production"
  }
}

# Diagnostic settings for OMS (Log Analytics)
resource "azurerm_monitor_diagnostic_setting" "aks_diagnostics" {
  name                       = "aks-diagnostics"
  target_resource_id         = azurerm_kubernetes_cluster.cluster.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.aks_logs.id

  enabled_log {
    category = "kube-apiserver"
    retention_policy {
      enabled = false
      days    = 0
    }
  }

  enabled_log {
    category = "kube-controller-manager"
    retention_policy {
      enabled = false
      days    = 0
    }
  }

  enabled_log {
    category = "cluster-autoscaler"
    retention_policy {
      enabled = false
      days    = 0
    }
  }

  metric {
    category = "AllMetrics"
    enabled  = true
    retention_policy {
      enabled = false
      days    = 0
    }
  }
}
