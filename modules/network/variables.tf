variable "resource_group_name" {
  type        = string
  description = "Name of the resource group"
}

variable "location" {
  type        = string
  description = "Azure region for resources"
}

variable "vnet_cidr" {
  type        = string
  description = "Address space for the virtual network"
}

variable "subnet_prefixes" {
  type        = map(string)
  description = "Map of subnet names to CIDR prefixes"
}
