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

variable "postgres_vm_size" {
  type    = "string"
  default = "Standard_DS2_v3"
}
