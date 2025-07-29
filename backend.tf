terraform {
  backend "azurerm" {
    resource_group_name  = "cst8918-final-project-group-4"
    storage_account_name = "abou0344tfstate"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}
