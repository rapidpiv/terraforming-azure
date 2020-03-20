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

    lb_router     = "${module.pas.web_lb_name}"

    dns_opsmanager = "${module.ops_manager.dns_name}"
    # dns_web        = "${azurerm_dns_a_record.web.name}.${azurerm_dns_a_record.web.zone_name}"
    # dns_credhub    = "${azurerm_dns_a_record.credhub.name}.${azurerm_dns_a_record.credhub.zone_name}"
    # dns_uaa        = "${azurerm_dns_a_record.uaa.name}.${azurerm_dns_a_record.uaa.zone_name}"

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
output "iaas" {
  value = "azure"
}

output "location" {
  value = "${var.location}"
}

output "subscription_id" {
  sensitive = true
  value     = "${var.subscription_id}"
}

output "tenant_id" {
  sensitive = true
  value     = "${var.tenant_id}"
}

output "client_id" {
  sensitive = true
  value     = "${var.client_id}"
}

output "client_secret" {
  sensitive = true
  value     = "${var.client_secret}"
}

output "ops_manager_dns" {
  value = "${module.ops_manager.dns_name}"
}

output "optional_ops_manager_dns" {
  value = "${module.ops_manager.optional_dns_name}"
}

output "mysql_dns" {
  value = "${module.pas.mysql_dns}"
}

output "tcp_domain" {
  value = "${module.pas.tcp_domain}"
}

output "sys_domain" {
  value = "${module.pas.sys_domain}"
}

output "apps_domain" {
  value = "${module.pas.apps_domain}"
}

output "env_dns_zone_name_servers" {
  value = "${module.infra.dns_zone_name_servers}"
}

output "ssl_cert" {
  sensitive = true
  value     = "${length(module.certs.ssl_cert) > 0 ? module.certs.ssl_cert : var.ssl_cert}"
}

output "ssl_private_key" {
  sensitive = true
  value     = "${length(module.certs.ssl_private_key) > 0 ? module.certs.ssl_private_key : var.ssl_private_key}"
}

output "iso_seg_ssl_cert" {
  sensitive = true
  value     = "${module.isolation_segment.ssl_cert}"
}

output "iso_seg_ssl_private_key" {
  sensitive = true
  value     = "${module.isolation_segment.ssl_private_key}"
}

output "web_lb_name" {
  value = "${module.pas.web_lb_name}"
}

output "diego_ssh_lb_name" {
  value = "${module.pas.diego_ssh_lb_name}"
}

output "mysql_lb_name" {
  value = "${module.pas.mysql_lb_name}"
}

output "tcp_lb_name" {
  value = "${module.pas.tcp_lb_name}"
}

output "network_name" {
  value = "${module.infra.network_name}"
}

output "infrastructure_subnet_name" {
  value = "${module.infra.infrastructure_subnet_name}"
}

output "infrastructure_subnet_cidr" {
  value = "${module.infra.infrastructure_subnet_cidr}"
}

output "infrastructure_subnet_gateway" {
  value = "${module.infra.infrastructure_subnet_gateway}"
}

# TODO(cdutra): PAS

output "pas_subnet_name" {
  value = "${module.pas.pas_subnet_name}"
}

output "pas_subnet_cidr" {
  value = "${module.pas.pas_subnet_cidr}"
}

output "pas_subnet_gateway" {
  value = "${module.pas.pas_subnet_gateway}"
}

output "services_subnet_name" {
  value = "${module.pas.services_subnet_name}"
}

output "services_subnet_cidr" {
  value = "${module.pas.services_subnet_cidr}"
}

output "services_subnet_gateway" {
  value = "${module.pas.services_subnet_gateway}"
}


output "pcf_resource_group_name" {
  value = "${module.infra.resource_group_name}"
}

output "ops_manager_security_group_name" {
  value = "${module.infra.security_group_name}"
}

output "bosh_deployed_vms_security_group_name" {
  value = "${module.infra.bosh_deployed_vms_security_group_name}"
}

output "bosh_root_storage_account" {
  value = "${module.infra.bosh_root_storage_account}"
}

output "ops_manager_storage_account" {
  value = "${module.ops_manager.ops_manager_storage_account}"
}

output "cf_storage_account_name" {
  value = "${module.pas.cf_storage_account_name}"
}

output "cf_storage_account_access_key" {
  sensitive = true
  value     = "${module.pas.cf_storage_account_access_key}"
}

output "cf_droplets_storage_container" {
  value = "${module.pas.cf_droplets_storage_container_name}"
}

output "cf_packages_storage_container" {
  value = "${module.pas.cf_packages_storage_container_name}"
}

output "cf_resources_storage_container" {
  value = "${module.pas.cf_resources_storage_container_name}"
}

output "cf_buildpacks_storage_container" {
  value = "${module.pas.cf_buildpacks_storage_container_name}"
}

output "ops_manager_ssh_public_key" {
  sensitive = true
  value     = "${module.ops_manager.ops_manager_ssh_public_key}"
}

output "ops_manager_ssh_private_key" {
  sensitive = true
  value     = "${module.ops_manager.ops_manager_ssh_private_key}"
}

output "ops_manager_public_ip" {
  value = "${module.ops_manager.ops_manager_public_ip}"
}

output "ops_manager_ip" {
  value = "${module.ops_manager.ops_manager_public_ip}"
}

output "optional_ops_manager_public_ip" {
  value = "${module.ops_manager.optional_ops_manager_public_ip}"
}

output "ops_manager_private_ip" {
  value = "${module.ops_manager.ops_manager_private_ip}"
}

output "isolation_segment" {
  value = {
    "lb_name" = "${module.isolation_segment.lb_name}"
  }
}

# Deprecated properties

output "management_subnet_name" {
  value = "${module.infra.infrastructure_subnet_name}"
}

output "management_subnets" {
  value = ["${module.infra.infrastructure_subnet_name}"]
}

output "management_subnet_cidrs" {
  value = ["${module.infra.infrastructure_subnet_cidrs}"]
}

output "management_subnet_gateway" {
  value = "${module.infra.infrastructure_subnet_gateway}"
}

output "infrastructure_subnet_cidrs" {
  value = "${module.infra.infrastructure_subnet_cidrs}"
}

output "pas_subnet_cidrs" {
  value = "${module.pas.pas_subnet_cidrs}"
}

output "services_subnet_cidrs" {
  value = "${module.pas.services_subnet_cidrs}"
}

output "services_subnets" {
  value = ["${module.pas.services_subnet_name}"]
}

output "infrastructure_subnets" {
  value = ["${module.infra.infrastructure_subnet_name}"]
}

output "pas_subnets" {
  value = ["${module.pas.pas_subnet_name}"]
}
