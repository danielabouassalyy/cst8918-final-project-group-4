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

  # 3. Point at your new remote‐state backend in the CDTO subscription
  backend "azurerm" {
    subscription_id       = "4f28dd96-a497-4f49-8d77-0c39fc199087"
    resource_group_name   = "tfstate-rg"
    storage_account_name  = "abou0344tfstatecdo"
    container_name        = "tfstate"
    key                   = "terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
  subscription_id = "4f28dd96-a497-4f49-8d77-0c39fc199087"
}
