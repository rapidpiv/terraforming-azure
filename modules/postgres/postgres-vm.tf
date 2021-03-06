resource random_string "pg_vm_storage_account_name" {
  length  = 20
  special = false
  upper   = false
}

resource "azurerm_public_ip" "pg_vm_public_ip" {

  count                   = "${var.postgres_vm_count}"

  name                    = "${var.env_name}-pg-public-ip-${count.index}"
  location                = "${var.location}"
  resource_group_name     = "${var.resource_group_name}"
  allocation_method       = "Static"
  sku                 = "Standard"
  idle_timeout_in_minutes = 30
}

resource "azurerm_network_interface" "pg_vm_nic" {

  count                   = "${var.postgres_vm_count}"

  name                      = "${var.env_name}-pg-vm-nic-${count.index}"
  location                  = "${var.location}"
  resource_group_name       = "${var.resource_group_name}"
  network_security_group_id = "${var.security_group_id}"


  ip_configuration {
    primary                       = true
    name                          = "${var.env_name}-pg-vm-rw-ip-config-${count.index}"
    subnet_id                     = "${var.subnet_id}"
    private_ip_address_allocation = "static"
    private_ip_address            = "${cidrhost(var.postgres_subnet_cidr, 5+count.index)}"
    public_ip_address_id          = "${element(azurerm_public_ip.pg_vm_public_ip.*.id, count.index)}"
  }

  ip_configuration {
    name                          = "${var.env_name}-pg-vm-ro-ip-config-${count.index}"
    subnet_id                     = "${var.subnet_id}"
    private_ip_address_allocation = "static"
    private_ip_address            = "${cidrhost(var.postgres_subnet_cidr, 10+count.index)}"
  }
}

resource "azurerm_network_interface_backend_address_pool_association" "pg-vm-nic-rw-backend-pool-association" {

  count                   = "${var.postgres_vm_count}"

  network_interface_id    = "${element(azurerm_network_interface.pg_vm_nic.*.id, count.index)}"
  ip_configuration_name   = "${var.env_name}-pg-vm-rw-ip-config-${count.index}"
  backend_address_pool_id = "${azurerm_lb_backend_address_pool.pg-lb-rw-backend-pool.id}"
}

resource "azurerm_network_interface_backend_address_pool_association" "pg-vm-nic-ro-backend-pool-association" {

  count                   = "${var.postgres_vm_count}"

  network_interface_id    = "${element(azurerm_network_interface.pg_vm_nic.*.id, count.index)}"
  ip_configuration_name   = "${var.env_name}-pg-vm-ro-ip-config-${count.index}"
  backend_address_pool_id = "${azurerm_lb_backend_address_pool.pg-lb-ro-backend-pool.id}"
}

resource "azurerm_availability_set" "pg_vm_av_set" {

  name                         = "${var.env_name}-pg-vm-av-set"
  location                      = "${var.location}"
  resource_group_name       = "${var.resource_group_name}"
  platform_fault_domain_count  = 2
  platform_update_domain_count = 2
  managed                      = true
}

resource "azurerm_virtual_machine" "pg_vm" {

  count                   = "${var.postgres_vm_count}"
  
  name = "${var.env_name}-pg-vm-${count.index}"
  location                      = "${var.location}"
  resource_group_name       = "${var.resource_group_name}"
  availability_set_id = "${azurerm_availability_set.pg_vm_av_set.id}"
  network_interface_ids         = ["${element(azurerm_network_interface.pg_vm_nic.*.id, count.index)}"]
  vm_size                  = "${var.postgres_vm_size}"

  storage_os_disk {
    name              = "pg-disk-${count.index}.vhd"
    caching           = "ReadWrite"
    os_type           = "linux"
    create_option     = "FromImage"
    disk_size_gb      = "150"
    managed_disk_type = "Premium_LRS"
  }

  os_profile {
    computer_name  = "pg-vm-${count.index}"
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

  connection {
    type        = "ssh"
    user        = "pgadmin"
    private_key = "${var.postgres_private_key}"
  }

  provisioner "file" {
    source      = "${path.module}/add-secondary-ip.sh"
    destination = "/tmp/add-secondary-ip.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/add-secondary-ip.sh",
      "sudo /tmp/add-secondary-ip.sh ${cidrhost(var.postgres_subnet_cidr, 10+count.index)} ${cidrnetmask(var.postgres_subnet_cidr)}",
    ]
  }
}
