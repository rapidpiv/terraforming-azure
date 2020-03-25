locals {
  stable_config = {

    location         = "${var.location}"
    environment_name = "${var.env_name}"

    network             = "${azurerm_virtual_network.pg_virtual_network.name}"
    resource_group_name = "${azurerm_resource_group.pg_resource_group.name}"

    postgres_private_key = "${tls_private_key.pg_key.private_key_pem}"
    postgres_public_key  = "${tls_private_key.pg_key.public_key_openssh}"

    # postgres_public_ip   = "${module.ops_manager.ops_manager_public_ip}"

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
