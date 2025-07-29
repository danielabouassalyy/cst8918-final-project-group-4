module "blob-backend" {
  source               = "./modules/blob-backend"
  resource_group_name  = "cst8918-final-project-group-4"
  location             = "Canada Central"
  storage_account_name = "abou0344tfstate"
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

module "aks" {
  source = "./modules/aks/test"

  aks_cluster_name    = "kubernetes_cluster"
  location            = "Canada Central"
  resource_group_name = "cst8918-final-project-group-4"
}

module "redis" {
  source = "kumarvna/redis/azurerm"

  # By default, this module will create a resource group
  # proivde a name to use an existing resource group and set the argument 
  # to `create_resource_group = false` if you want to existing resoruce group. 
  # If you use existing resrouce group location will be the same as existing RG.
  create_resource_group = false
  resource_group_name   = "cst8918-final-project-group-4"
  location              = "Canada Central"

  # Configuration to provision a Standard Redis Cache
  # Specify `shard_count` to create on the Redis Cluster
  # Add patch_schedle to this object to enable redis patching schedule
  redis_server_settings = {
    demoredischache-shared = {
      sku_name            = "Standard"
      capacity            = 2
      shard_count         = 3
      zones               = ["1", "2", "3"]
      enable_non_ssl_port = true
    }
  }

  redis_configuration = {
    maxmemory_reserved = 2
    maxmemory_delta    = 2
    maxmemory_policy   = "allkeys-lru"
  }

  patch_schedule = {
    day_of_week    = "Saturday"
    start_hour_utc = 10
  }

  firewall_rules = {
    access_to_azure = {
      start_ip = "1.2.3.4"
      end_ip   = "1.2.3.4"
    },
    desktop_ip = {
      start_ip = "49.204.228.223"
      end_ip   = "49.204.228.223"
    }
  }

  enable_private_endpoint       = true
  virtual_network_name          = "vnet-shared-hub-westeurope-001"
  private_subnet_address_prefix = ["10.0.0.0/16"]

  log_analytics_workspace_name = "loganalytics-we-sharedtest2"

  # Tags for Azure Resources
  tags = {
    Environment = "test"
  }
}