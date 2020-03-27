locals {
  os_profiles = "${azurerm_virtual_machine.postgres_vm.*.os_profile}"
}
output "postgres_public_ips" {
  value = "${azurerm_public_ip.postgres_public_ip.*.ip_address}"
}

output "postgres_host_names" {
  value = "${local.os_profiles}"
}
