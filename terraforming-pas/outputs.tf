locals {
  stable_config = {

    location         = "${var.location}"
    environment_name = "${var.env_name}"

    network             = "${module.infra.network_name}"
    resource_group_name = "${module.infra.resource_group_name}"
    security_group_platform_vms_name = "${module.infra.bosh_deployed_vms_security_group_name}"
    security_group_opsmanager_name   = "${module.infra.security_group_name}"

    opsmanager_private_key = "${module.ops_manager.ops_manager_ssh_private_key}"
    opsmanager_public_key  = "${module.ops_manager.ops_manager_ssh_public_key}"
    opsmanager_public_ip   = "${module.ops_manager.ops_manager_public_ip}"
    opsmanager_password    = "${module.ops_manager.om_password}"
    opsmanager_decryption_password    = "${module.ops_manager.om_decryption_password}"
    opsman_vm_name         = "PAS-OpsManager-vm"

    container_opsmanager_image = "${module.ops_manager.ops_manager_storage_container}"

    storage_account_opsmanager = "${module.ops_manager.ops_manager_storage_account}"

    subnet_management_name     = "${module.infra.infrastructure_subnet_name}"
    subnet_management_id       = "${module.infra.infrastructure_subnet_id}"
    subnet_management_cidr     = "${module.infra.infrastructure_subnet_cidr}"
    subnet_management_gateway  = "${module.infra.infrastructure_subnet_gateway}"
    subnet_management_reserved = "${cidrhost(module.infra.infrastructure_subnet_cidr, 1)}-${cidrhost(module.infra.infrastructure_subnet_cidr, 10)}"

    credhub_provider_key     = "${module.pas.credhub_provider_key}"

    subnet_pas_name     = "${module.pas.pas_subnet_name}"
    subnet_pas_id       = "${module.pas.pas_subnet_id}"
    subnet_pas_cidr     = "${module.pas.pas_subnet_cidr}"
    subnet_pas_gateway  = "${module.pas.pas_subnet_gateway}"
    subnet_pas_reserved = "${cidrhost(module.pas.pas_subnet_cidr, 1)}-${cidrhost(module.pas.pas_subnet_cidr, 10)}"

    subnet_services_name     = "${module.pas.services_subnet_name}"
    subnet_services_id       = "${module.pas.services_subnet_id}"
    subnet_services_cidr     = "${module.pas.services_subnet_cidr}"
    subnet_services_gateway  = "${module.pas.services_subnet_gateway}"
    subnet_services_reserved = "${cidrhost(module.pas.services_subnet_cidr, 1)}-${cidrhost(module.pas.services_subnet_cidr, 15)}"

    lb_ssh     = "${module.pas.diego_ssh_lb_name}"
    lb_router     = "${module.pas.web_lb_name}"

    dns_opsmanager = "${module.ops_manager.dns_name}"
    dns_zone = "${module.infra.dns_zone_name}"

    subscription_id = "${var.subscription_id}"
    tenant_id       = "${var.tenant_id}"
    client_id       = "${var.client_id}"
    client_secret   = "${var.client_secret}"
  }
}

output "stable_config" {
  value     = "${jsonencode(local.stable_config)}"
  sensitive = false
}
