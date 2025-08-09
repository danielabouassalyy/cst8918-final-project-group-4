terraform {
  required_version = ">= 1.5.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.37.0"
    }
  }

  backend "azurerm" {
    # 🔒 Remote state location (your "OTHER" subscription)
    subscription_id      = "4f28dd96-a497-4f49-8d77-0c39fc199087"
    resource_group_name  = "cst8918-final-project-group-4"
    storage_account_name = "abou0344tfstate2"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"

    # ✅ Required for GitHub Actions OIDC
    use_oidc = true
  }
}
