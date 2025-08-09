provider "azurerm" {
  features {}

  # Ensure resources deploy to the same subscription as your state
  subscription_id = "4f28dd96-a497-4f49-8d77-0c39fc199087"
}
