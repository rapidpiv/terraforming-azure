provider "azurerm" {
  subscription_id = "${var.subscription_id}"
  client_id       = "${var.client_id}"
  client_secret   = "${var.client_secret}"
  tenant_id       = "${var.tenant_id}"
  environment     = "${var.cloud_name}"

  version = "~> 1.22"
}

terraform {
  required_version = "< 0.12.0"
}

# data "azurerm_subnet" "postgres_subnet" {
#   name                 = "${var.postgres_subnet_name}"
#   virtual_network_name = "${var.postgres_network_name}"
#   resource_group_name  = "${data.azurerm_resource_group.postgres_resource_group.name}"
# }

# data "azurerm_network_security_group" "postgres_security_group" {
#   name                = "${var.postgres_security_group_name}"
#   resource_group_name  = "${data.azurerm_resource_group.postgres_resource_group.name}"
# }

# data "azurerm_dns_zone" "postgres_dns_zone" {
#   name                = "poc-mod.siob.me"
#   resource_group_name  = "${data.azurerm_resource_group.postgres_resource_group.name}"
# }


resource "azurerm_resource_group" "pg_resource_group" {
  name     = "${var.env_name}"
  location = "${var.location}"
}


resource "azurerm_virtual_network" "pg_virtual_network" {
  name                = "${var.env_name}-virtual-network"
  depends_on          = ["azurerm_resource_group.pg_resource_group"]
  resource_group_name = "${azurerm_resource_group.pg_resource_group.name}"
  address_space       = "${var.pg_virtual_network_address_space}"
  location            = "${var.location}"
}

resource "azurerm_network_security_group" "pg_security_group" {
  name                = "${var.env_name}-pg-security-group"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.pg_resource_group.name}"

  security_rule {
    name                       = "internal-anything"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "ssh"
    priority                   = 200
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = 22
    source_address_prefixes    = "${var.ssh_trusted_sources}"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "dns"
    priority                   = 203
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = 53
    source_address_prefix      = "Internet"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "http"
    priority                   = 204
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = 80
    source_address_prefix      = "Internet"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "https"
    priority                   = 205
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = 443
    source_address_prefix      = "Internet"
    destination_address_prefix = "*"
  }

}

resource "azurerm_subnet" "pg_subnet" {
  name                      = "${var.env_name}-pg-subnet"
  depends_on                = ["azurerm_resource_group.pg_resource_group"]
  resource_group_name       = "${azurerm_resource_group.pg_resource_group.name}"
  virtual_network_name      = "${azurerm_virtual_network.pg_virtual_network.name}"
  address_prefix            = "${var.pg_subnet}"
  network_security_group_id = "${azurerm_network_security_group.pg_security_group.id}"
}

resource "tls_private_key" "pg_key" {
  algorithm = "RSA"
  rsa_bits  = "4096"
}

module "postgres" {
  source = "../modules/postgres"

  env_name = "${var.env_name}"
  location = "${var.location}"

  postgres_vm_size    = "${var.postgres_vm_size}"
  postgres_private_ip = "${cidrhost(azurerm_subnet.pg_subnet.address_prefix, 5)}"

  postgres_public_key = "${tls_private_key.pg_key.public_key_openssh}"

  resource_group_name  = "${azurerm_resource_group.pg_resource_group.name}"
  security_group_id   = "${azurerm_network_security_group.pg_security_group.id}"
  subnet_id           = "${azurerm_subnet.pg_subnet.id}"
}
