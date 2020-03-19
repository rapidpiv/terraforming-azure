provider "azurerm" {
  subscription_id = "${var.subscription_id}"
  client_id       = "${var.client_id}"
  client_secret   = "${var.client_secret}"
  tenant_id       = "${var.tenant_id}"
  environment     = "${var.cloud_name}"

  version = "~> 1.22"
}

terraform {
  required_version = "< 0.12.0"
}

# module "postgres" {
#   source = "../modules/postgres"

#   env_name = "${var.env_name}"
#   location = "${var.location}"

#   postgres_vm_size    = "${var.postgres_vm_size}"
#   postgres_private_ip = "${cidrhost(module.pas.services_subnet_cidr, 5)}"

#   resource_group_name = "${module.infra.resource_group_name}"
#   dns_zone_name       = "${module.infra.dns_zone_name}"
#   security_group_id   = "${module.infra.bosh_deployed_vms_security_group_id}"
#   subnet_id           = "${module.pas.services_subnet_id}"
# }
