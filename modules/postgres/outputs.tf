data "template_file" "data_id" {
  count = "${var.postgres_vm_count}"
  template = "${lookup(azurerm_virtual_machine.postgres_vm.*.os_profile[count.index], "computer_name")}"
}

output "postgres_public_ips" {
  value = "${azurerm_public_ip.postgres_public_ip.*.ip_address}"
}

output "postgres_host_names" {
  value = "${data.template_file.data_id.*.rendered}"
}
