resource "tls_private_key" "postgres" {
  algorithm = "RSA"
  rsa_bits  = "4096"
}

# resource "random_password" "ops_manager_password" {
#   length  = 16
#   special = false
# }

# resource "random_password" "ops_manager_decryption_password" {
#   length  = 30
#   special = false
# }

# # ==================== Storage
resource random_string "postgres_storage_account_name" {
  length  = 20
  special = false
  upper   = false
}

resource "azurerm_storage_account" "postgres_storage_account" {
  name                     = "${random_string.postgres_storage_account_name.result}"
  resource_group_name      = "${var.resource_group_name}"
  location                 = "${var.location}"
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    environment = "${var.env_name}"
    account_for = "postgres"
  }
}

# resource "azurerm_storage_container" "ops_manager_storage_container" {
#   name                  = "opsmanagerimage"
#   depends_on            = ["azurerm_storage_account.ops_manager_storage_account"]
#   storage_account_name  = "${azurerm_storage_account.ops_manager_storage_account.name}"
#   container_access_type = "private"
# }

# resource "azurerm_storage_blob" "ops_manager_image" {
#   name                   = "opsman.vhd"
#   resource_group_name    = "${var.resource_group_name}"
#   storage_account_name   = "${azurerm_storage_account.ops_manager_storage_account.name}"
#   storage_container_name = "${azurerm_storage_container.ops_manager_storage_container.name}"
#   source_uri             = "${var.ops_manager_image_uri}"
#   count                  = "${local.ops_man_vm}"
#   type                   = "page"
# }

# resource "azurerm_image" "ops_manager_image" {
#   name                = "ops_manager_image"
#   location            = "${var.location}"
#   resource_group_name = "${var.resource_group_name}"
#   count               = "${local.ops_man_vm}"

#   os_disk {
#     os_type  = "Linux"
#     os_state = "Generalized"
#     blob_uri = "${azurerm_storage_blob.ops_manager_image.url}"
#     size_gb  = 150
#   }
# }

# # ==================== DNS

# resource "azurerm_dns_a_record" "ops_manager_dns" {
#   name                = "pcf"
#   zone_name           = "${var.dns_zone_name}"
#   resource_group_name = "${var.resource_group_name}"
#   ttl                 = "60"
#   records             = ["${azurerm_public_ip.ops_manager_public_ip.ip_address}"]
# }

# resource "azurerm_dns_a_record" "optional_ops_manager_dns" {
#   name                = "pcf-optional"
#   zone_name           = "${var.dns_zone_name}"
#   resource_group_name = "${var.resource_group_name}"
#   ttl                 = "60"
#   records             = ["${azurerm_public_ip.optional_ops_manager_public_ip.ip_address}"]
#   count               = "${local.optional_ops_man_vm}"
# }

# # ==================== VMs

resource "azurerm_public_ip" "postgres_public_ip" {
  name                    = "${var.env_name}-postgres-public-ip"
  location                = "${var.location}"
  resource_group_name     = "${var.resource_group_name}"
  allocation_method       = "Static"
  idle_timeout_in_minutes = 30
}

resource "azurerm_network_interface" "postgres_nic" {
  name                      = "${var.env_name}-postgres-nic"
  depends_on                = ["azurerm_public_ip.postgres_public_ip"]
  location                  = "${var.location}"
  resource_group_name       = "${var.resource_group_name}"
  network_security_group_id = "${var.security_group_id}"

  ip_configuration {
    name                          = "${var.env_name}-postgres-ip-config"
    subnet_id                     = "${var.subnet_id}"
    private_ip_address_allocation = "static"
    private_ip_address            = "${var.postgres_private_ip}"
    public_ip_address_id          = "${azurerm_public_ip.postgres_public_ip.id}"
  }
}

# resource "azurerm_virtual_machine" "ops_manager_vm" {
#   name                          = "${var.env_name}-ops-manager-vm"
#   depends_on                    = ["azurerm_network_interface.ops_manager_nic"]
#   location                      = "${var.location}"
#   resource_group_name           = "${var.resource_group_name}"
#   network_interface_ids         = ["${azurerm_network_interface.ops_manager_nic.id}"]
#   vm_size                       = "${var.ops_manager_vm_size}"
#   delete_os_disk_on_termination = "true"
#   count                         = "${local.ops_man_vm}"

#   storage_image_reference {
#     id = "${azurerm_image.ops_manager_image.id}"
#   }

#   storage_os_disk {
#     name              = "opsman-disk.vhd"
#     caching           = "ReadWrite"
#     os_type           = "linux"
#     create_option     = "FromImage"
#     disk_size_gb      = "150"
#     managed_disk_type = "Premium_LRS"
#   }

#   os_profile {
#     computer_name  = "${var.env_name}-ops-manager"
#     admin_username = "ubuntu"
#   }

#   os_profile_linux_config {
#     disable_password_authentication = true

#     ssh_keys {
#       path     = "/home/ubuntu/.ssh/authorized_keys"
#       key_data = "${tls_private_key.ops_manager.public_key_openssh}"
#     }
#   }
# }

  resource "azurerm_linux_virtual_machine" "postgres_vm" {

    name = "${var.env_name}-postgres-vm"
    location                      = "${var.location}"
    resource_group_name       = "${var.resource_group_name}"
    network_interface_ids         = ["${azurerm_network_interface.postgres_nic.id}"]
    size                  = "${var.postgres_vm_size}"

    os_disk {
      name              = "postgres-disk.vhd"
      caching           = "ReadWrite"
      storage_account_type = "Premium_LRS"
    }

    source_image_reference {
      publisher = "OpenLogic"
      offer     = "CentOS"
      sku       = "7.5"
      version   = "latest"
    }

    computer_name  = "${var.env_name}-postgres"
    admin_username = "admin"
    disable_password_authentication = true

    admin_ssh_key {
      username       = "admin"
      public_key     = "${tls_private_key.postgres.public_key_openssh}"
    }

    boot_diagnostics {
      storage_account_uri = "${azurerm_storage_account.postgres_storage_account.primary_blob_endpoint}"
    }

    tags = {
      environment = "${var.env_name}"
    }
}
