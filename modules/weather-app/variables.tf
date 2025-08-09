variable "resource_group_name" {
  type        = string
  description = "Name of the resource group (from network module)"
}

variable "location" {
  type        = string
  description = "Azure location"
}

variable "acr_name" {
  type        = string
  description = "Name for the Azure Container Registry"
}

variable "aks_cluster_name" {
  type        = string
  description = "Name of the AKS cluster to deploy to"
}

variable "aks_resource_group" {
  type        = string
  description = "Resource group for the AKS cluster"
}

variable "redis_hostname" {
  type        = string
  description = "Hostname of the Redis cache"
}

variable "redis_access_key" {
  type        = string
  description = "Access key for the Redis cache"
}

variable "image_tag" {
  type        = string
  description = "Docker image tag (use GitHub SHA)"
}
