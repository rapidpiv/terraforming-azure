resource "random_password" "credhub_internal_provider_key" {
  length  = 24
  special = false
}
