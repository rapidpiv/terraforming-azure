output "postgres_public_ips" {
  value = "${azurerm_public_ip.postgres_public_ip.*.ip_address}"
}
