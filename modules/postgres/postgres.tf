resource random_string "postgres_storage_account_name" {
  length  = 20
  special = false
  upper   = false
}

# resource "azurerm_storage_account" "postgres_storage_account" {
#   name                     = "${random_string.postgres_storage_account_name.result}"
#   resource_group_name      = "${var.resource_group_name}"
#   location                 = "${var.location}"
#   account_tier             = "Standard"
#   account_replication_type = "LRS"

#   tags = {
#     environment = "${var.env_name}"
#     account_for = "postgres"
#   }
# }

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

resource "azurerm_virtual_machine" "postgres_vm" {

  name = "${var.env_name}-postgres-vm"
  location                      = "${var.location}"
  resource_group_name       = "${var.resource_group_name}"
  network_interface_ids         = ["${azurerm_network_interface.postgres_nic.id}"]
  vm_size                  = "${var.postgres_vm_size}"

  storage_os_disk {
    name              = "postgres-disk.vhd"
    caching           = "ReadWrite"
    os_type           = "linux"
    create_option     = "FromImage"
    disk_size_gb      = "150"
    managed_disk_type = "Premium_LRS"
  }

  os_profile {
    computer_name  = "${var.env_name}-postgres"
    admin_username = "pgadmin"
  }

  os_profile_linux_config {
    disable_password_authentication = true
    ssh_keys {
      path     = "/home/pgadmin/.ssh/authorized_keys"
      key_data = "${var.postgres_public_key}"
    }
  }

  storage_image_reference {
    publisher = "OpenLogic"
    offer     = "CentOS"
    sku       = "7.5"
    version   = "latest"
  }

  tags = {
    environment = "${var.env_name}"
  }

  provisioner "remote-exec" {
    inline = ["sudo yum -y install python"]

    connection {
      type        = "ssh"
      user        = "pgadmin"
      private_key = "${var.postgres_private_key}"
    }
  }
}
