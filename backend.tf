terraform {
  # 1. Pin the Terraform CLI version
  required_version = ">= 1.5.0"

  # 2. Pin your AzureRM provider
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.37.0"
    }
  }

  # 3. Remote state backend in the **OTHER** subscription
  backend "azurerm" {
    subscription_id      = "4f28dd96-a497-4f49-8d77-0c39fc199087" # <-- other sub
    resource_group_name  = "cst8918-final-project-group-4"
    storage_account_name = "abou0344tfstate2"                      # <-- new SA
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}

provider "azurerm" {
  features {}

  # Ensure *all* resources target the **OTHER** subscription
  subscription_id = "4f28dd96-a497-4f49-8d77-0c39fc199087"
}
