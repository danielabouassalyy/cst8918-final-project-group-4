# 1. Provision the ACR
resource "azurerm_container_registry" "acr" {
  name                = var.acr_name
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = "Basic"
  admin_enabled       = true
}

# 2. Get the AKS cluster data
data "azurerm_kubernetes_cluster" "cluster" {
  name                = var.aks_cluster_name
  resource_group_name = var.aks_resource_group
}

# 3. Kubernetes provider config
provider "kubernetes" {
  host                   = data.azurerm_kubernetes_cluster.cluster.kube_config[0].host
  client_certificate     = base64decode(data.azurerm_kubernetes_cluster.cluster.kube_config[0].client_certificate)
  client_key             = base64decode(data.azurerm_kubernetes_cluster.cluster.kube_config[0].client_key)
  cluster_ca_certificate = base64decode(data.azurerm_kubernetes_cluster.cluster.kube_config[0].cluster_ca_certificate)
}

# 4. Namespace
resource "kubernetes_namespace" "app" {
  metadata {
    name = "weather-app"
  }
}

# 5. Deployment
resource "kubernetes_deployment" "app" {
  metadata {
    name      = "weather-app"
    namespace = kubernetes_namespace.app.metadata[0].name
    labels = { app = "weather-app" }
  }

  spec {
    replicas = 2
    selector {
      match_labels = { app = "weather-app" }
    }
    template {
      metadata {
        labels = { app = "weather-app" }
      }
      spec {
        container {
          name  = "weather-app"
          image = "${azurerm_container_registry.acr.login_server}/weather-app:${var.image_tag}"
          ports {
            container_port = 3000
          }
          env {
            name  = "REDIS_HOST"
            value = var.redis_hostname
          }
          env {
            name  = "REDIS_KEY"
            value = var.redis_access_key
          }
        }
      }
    }
  }
}

# 6. Service (LoadBalancer)
resource "kubernetes_service" "app" {
  metadata {
    name      = "weather-app-svc"
    namespace = kubernetes_namespace.app.metadata[0].name
  }

  spec {
    selector = { app = "weather-app" }
    port {
      port        = 80
      target_port = 3000
    }
    type = "LoadBalancer"
  }
}
