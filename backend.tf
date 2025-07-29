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

  # 3. Your existing remote‐state backend
  backend "azurerm" {
    resource_group_name  = "cst8918-final-project-group-4"
    storage_account_name = "abou0344tfstate"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
}
