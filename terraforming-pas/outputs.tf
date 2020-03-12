locals {
  stable_config = {

    location         = "${var.location}"
    environment_name = "${var.env_name}"

    # network             = azurerm_virtual_network.control_plane.name
    resource_group_name = "${module.infra.resource_group_name}"
    # security_group_platform_vms_name = azurerm_network_security_group.internal_traffic.name
    # security_group_opsmanager_name   = azurerm_network_security_group.ops_manager.name

    # opsmanager_private_key = tls_private_key.ops_manager.private_key_pem
    opsmanager_public_key  = "${module.ops_manager.ops_manager_ssh_public_key}"
    opsmanager_public_ip   = "${module.ops_manager.ops_manager_public_ip}"
    # opsmanager_password    = random_password.ops_manager_password.result
    # opsman_vm_name         = "ControlPlane-OpsManager-vm"

    container_opsmanager_image = "${module.ops_manager.ops_manager_storage_container}"

    storage_account_opsmanager = "${module.ops_manager.ops_manager_storage_account}"

    # subnet_management_name     = azurerm_subnet.management.name
    subnet_management_id       = "${module.infra.infrastructure_subnet_id}"
    # subnet_management_cidr     = azurerm_subnet.management.address_prefix
    # subnet_management_gateway  = cidrhost(azurerm_subnet.management.address_prefix, 1)
    # subnet_management_reserved = "${cidrhost(azurerm_subnet.management.address_prefix, 1)}-${cidrhost(azurerm_subnet.management.address_prefix, 5)}"

    # subnet_control-plane_name     = azurerm_subnet.concourse.name
    # subnet_control-plane_id       = azurerm_subnet.concourse.id
    # subnet_control-plane_cidr     = azurerm_subnet.concourse.address_prefix
    # subnet_control-plane_gateway  = cidrhost(azurerm_subnet.concourse.address_prefix, 1)
    # subnet_control-plane_reserved = "${cidrhost(azurerm_subnet.concourse.address_prefix, 1)}-${cidrhost(azurerm_subnet.concourse.address_prefix, 5)}"

    # lb_web     = azurerm_lb.web.name
    # lb_credhub = azurerm_lb.credhub.name
    # lb_uaa     = azurerm_lb.credhub.name
    # # lb_uaa     = azurerm_lb.uaa.name

    # dns_opsmanager = "${azurerm_dns_a_record.opsmanager.name}.${azurerm_dns_a_record.opsmanager.zone_name}"
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
