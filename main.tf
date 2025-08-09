# ---------------- Blob backend bootstrap (creates SA + container) ----------------
module "blob-backend" {
  source               = "./modules/blob-backend"
  resource_group_name  = "cst8918-final-project-group-4"
  location             = "Canada Central"
  storage_account_name = "abou0344tfstate2"
  container_name       = "tfstate"
}

# ---------------- Network (vnet + 4 subnets) ----------------
module "network" {
  source              = "./modules/network"
  resource_group_name = "cst8918-final-project-group-4"
  location            = "Canada Central"

  vnet_cidr = "10.0.0.0/14"
  subnet_prefixes = {
    prod  = "10.0.0.0/16"
    test  = "10.1.0.0/16"
    dev   = "10.2.0.0/16"
    admin = "10.3.0.0/16"
  }
}

# ---------------- ACR ----------------
module "acr" {
  source              = "./modules/acr"
  resource_group_name = "cst8918-final-project-group-4"
  location            = "Canada Central"
  acr_name            = "cst8918group4acr0tnj2"
}

# ---------------- AKS TEST ----------------
module "aks_test" {
  source              = "./modules/aks/test"
  aks_cluster_name    = "aks-test-cluster"
  location            = "Canada Central"
  resource_group_name = "cst8918-final-project-group-4"
  subnet_id           = module.network.subnet_ids["test"]
}

# ---------------- AKS PROD ----------------
module "aks_prod" {
  source              = "./modules/aks/prod"
  aks_cluster_name    = "aks-prod-cluster"
  location            = "Canada Central"
  resource_group_name = "cst8918-final-project-group-4"
  subnet_id           = module.network.subnet_ids["prod"]
}

# ---------------- Redis TEST (Basic; no vnet injection) ----------------
module "redis_test" {
  source              = "./modules/redis/test"
  name                = "cst8918-redis-test-0tnj2"
  location            = "Canada Central"
  resource_group_name = "cst8918-final-project-group-4"
  subnet_id           = module.network.subnet_ids["test"]
}

# ---------------- Redis PROD ----------------
module "redis_prod" {
  source              = "./modules/redis/prod"
  name                = "cst8918-redis-prod-0tnj2"
  location            = "Canada Central"
  resource_group_name = "cst8918-final-project-group-4"
  subnet_id           = module.network.subnet_ids["prod"]
}

# ---------------- Read clusters for kubelet identities ----------------
data "azurerm_kubernetes_cluster" "aks_test" {
  name                = "aks-test-cluster"
  resource_group_name = "cst8918-final-project-group-4"
  depends_on          = [module.aks_test]
}

data "azurerm_kubernetes_cluster" "aks_prod" {
  name                = "aks-prod-cluster"
  resource_group_name = "cst8918-final-project-group-4"
  depends_on          = [module.aks_prod]
}

# ---------------- AcrPull for kubelet identities ----------------
# (test is already assigned; keep only prod here)
resource "azurerm_role_assignment" "acr_pull_prod" {
  scope                = module.acr.id
  role_definition_name = "AcrPull"
  principal_id         = data.azurerm_kubernetes_cluster.aks_prod.kubelet_identity[0].object_id
}

# (outputs, if you had them, can stay as-is)
