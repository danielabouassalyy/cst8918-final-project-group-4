# Log Analytics Workspace (unique name)
resource "azurerm_log_analytics_workspace" "aks_logs" {
  name                            = "aks-test-logs-0tnji9"
  location                        = var.location
  resource_group_name             = var.resource_group_name
  sku                             = "PerGB2018"
  retention_in_days               = 30
  allow_resource_only_permissions = true
  internet_ingestion_enabled      = true
  internet_query_enabled          = true
}

# AKS Test Cluster
resource "azurerm_kubernetes_cluster" "cluster" {
  name                = var.aks_cluster_name
  dns_prefix          = var.aks_cluster_name
  location            = var.location
  resource_group_name = var.resource_group_name
  kubernetes_version  = "1.32.6"

  default_node_pool {
    name           = "default"
    node_count     = 1
    type           = "VirtualMachineScaleSets"
    vm_size        = "Standard_B2s"
    vnet_subnet_id = var.subnet_id
  }

  network_profile {
    network_plugin    = "azure"
    network_policy    = "azure"
    load_balancer_sku = "standard"
    outbound_type     = "loadBalancer"
    # must NOT overlap your VNet 10.0.0.0/14
    service_cidr   = "172.16.0.0/16"
    dns_service_ip = "172.16.0.10"
  }

  identity { type = "SystemAssigned" }
  role_based_access_control_enabled = true
  tags                              = { Environment = "test" }
}

# Diagnostics to LA workspace
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
