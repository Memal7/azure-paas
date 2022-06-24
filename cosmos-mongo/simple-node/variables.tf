variable "resource_group_location" {
  type    = string
  default = "eastus"
}

variable "resource_group_name_prefix" {
  type    = string
  default = "rg-cosmos-demo"
}

variable "failover_location" {
  type    = string
  default = "westus"
}
