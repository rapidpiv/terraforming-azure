variable "env_name" {}

variable "cloud_name" {
  description = "The Azure cloud environment to use. Available values at https://www.terraform.io/docs/providers/azurerm/#environment"
  default     = "public"
}

variable "subscription_id" {}

variable "tenant_id" {}

variable "client_id" {}

variable "client_secret" {}

variable "location" {}

variable "dns_zone" {}

variable "pg_virtual_network_address_space" {
  type    = "list"
  default = ["10.0.0.0/16"]
}

variable "pg_subnet" {
  type    = "string"
  default = "10.0.8.0/26"
}

variable "postgres_vm_size" {
  type    = "string"
  default = "Standard_F4s"
  # default = "Standard_D2S_v3"
}

variable "postgres_vm_count" {
  default = 3
}

variable "ssh_trusted_sources" {
  type    = "list"
}
