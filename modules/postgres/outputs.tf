output "postgres_public_ip" {
  value = "${azurerm_public_ip.postgres_public_ip.ip_address}"
}
