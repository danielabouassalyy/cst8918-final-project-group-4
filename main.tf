module "blob-backend" {
  source               = "./modules/blob-backend"
  resource_group_name  = "cst8918-final-project-group-4"
  location             = "Canada Central"
  storage_account_name = "abou0344tfstate2"
  container_name       = "tfstate"
}

module "network" {
  source              = "./modules/network"
  resource_group_name = "cst8918-final-project-group-4"
  location            = "Canada Central"
  vnet_cidr           = "10.0.0.0/14"
  subnet_prefixes = {
    prod  = "10.0.0.0/16"
    test  = "10.1.0.0/16"
    dev   = "10.2.0.0/16"
    admin = "10.3.0.0/16"
  }
}

module "aks_test" {
  source = "./modules/aks/test"

  aks_cluster_name    = "aks-test-cluster"
  location            = "Canada Central"
  resource_group_name = "cst8918-final-project-group-4"

  subnet_id = module.network.subnet_ids["test"]
}
module "aks_prod" {
  source              = "./modules/aks/prod"
  aks_cluster_name    = "aks-prod-cluster" # <-- was aks-test-cluster
  location            = "Canada Central"
  resource_group_name = "cst8918-final-project-group-4"
  subnet_id           = module.network.subnet_ids["prod"]
}


module "redis_test" {
  source              = "./modules/redis/test"
  name                = "cst8918-redis-0tnj2"
  location            = "Canada East"
  resource_group_name = "cst8918-final-project-group-4"
  subnet_id           = module.network.subnet_ids["test"]
}

module "redis_prod" {
  source              = "./modules/redis/prod"
  name                = "cst8918-redis-prod-0tnji9" # if taken, change the suffix
  location            = "Canada Central"
  resource_group_name = "cst8918-final-project-group-4"
  subnet_id           = module.network.subnet_ids["prod"]
}

module "acr" {
  source              = "./modules/acr"
  resource_group_name = "cst8918-final-project-group-4"
  location            = "Canada Central"
  acr_name            = "cst8918group4acr0tnj2" # change if not available; must be unique
}

# Read the existing TEST AKS to get the kubelet identity
#data "azurerm_kubernetes_cluster" "aks_test" {
#  name                = "aks-test-cluster"
#  resource_group_name = "cst8918-final-project-group-4"
#}

# Give AKS permission to pull from ACR
#resource "azurerm_role_assignment" "acr_pull_test" {
#  scope                = module.acr.id
#  role_definition_name = "AcrPull"
#  principal_id         = data.azurerm_kubernetes_cluster.aks_test.kubelet_identity[0].object_id
#}
