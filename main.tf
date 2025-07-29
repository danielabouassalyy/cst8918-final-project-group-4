provider "azurerm" {
  features {}
}

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
