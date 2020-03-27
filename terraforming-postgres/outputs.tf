locals {
  stable_config = {

    location         = "${var.location}"
    environment_name = "${var.env_name}"

    network             = "${azurerm_virtual_network.pg_virtual_network.name}"
    resource_group_name = "${azurerm_resource_group.pg_resource_group.name}"

    postgres_private_key = "${tls_private_key.pg_key.private_key_pem}"
    postgres_public_key  = "${tls_private_key.pg_key.public_key_openssh}"

    postgres_public_ips   = "${module.postgres.postgres_public_ips}"

    subscription_id = "${var.subscription_id}"
    tenant_id       = "${var.tenant_id}"
    client_id       = "${var.client_id}"
    client_secret   = "${var.client_secret}"
  }

  ansible_hosts = {
    all = "123"
  }
}

output "stable_config" {
  value     = "${jsonencode(local.stable_config)}"
  sensitive = false
}

output "ansible_hosts" {
  value     = "${yamlencode(local.ansible_hosts)}"
  sensitive = false
}
