output "postgres_public_ips" {
  value = "${azurerm_public_ip.pg_vm_public_ip.*.ip_address}"
}

output "postgres_host_names" {
  value = "${azurerm_virtual_machine.pg_vm.*.os_profile}"
}
