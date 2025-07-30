variable "resource_group_name" {
  type        = string
  description = "Name of the RG for the Terraform backend"
}

variable "location" {
  type        = string
  description = "Azure region to deploy the backend"
}

variable "aks_cluster_name" {
  type        = string
  description = "Name of the AKS cluster"
}

variable "subnet_id" {
  type        = string
  description = "Subnet ID for the AKS node pool"
}