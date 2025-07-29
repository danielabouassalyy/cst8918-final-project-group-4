variable "resource_group_name" {
  type        = string
  description = "Name of the RG for the Terraform backend"
}

variable "location" {
  type        = string
  description = "Azure region to deploy the backend"
}

variable "storage_account_name" {
  type        = string
  description = "Name of the storage account for Terraform state"
}

variable "container_name" {
  type        = string
  description = "Blob container name for Terraform state"
}
