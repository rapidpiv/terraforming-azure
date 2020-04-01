# loadbalancer to direct traffic to master node
resource "azurerm_public_ip" "pg-master-lb-public-ip" {
  name                = "pg-master-lb-public-ip"
  location            = "${var.location}"
  resource_group_name = "${var.resource_group_name}"
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_lb" "pg-master-lb" {
  name                = "${var.env_name}-pg-master-lb"
  location            = "${var.location}"
  resource_group_name = "${var.resource_group_name}"
  sku                 = "Standard"

  frontend_ip_configuration = {
    name                 = "frontendip"
    public_ip_address_id = "${azurerm_public_ip.pg-master-lb-public-ip.id}"
  }
}

resource "azurerm_lb_backend_address_pool" "pg-master-lb-backend-pool" {
  name                = "pg-master-lb-backend-pool"
  resource_group_name = "${var.resource_group_name}"
  loadbalancer_id     = "${azurerm_lb.pg-master-lb.id}"
}

resource "azurerm_lb_probe" "pg-master-lb-probe" {
  name                = "pg-master-lb-probe"
  resource_group_name = "${var.resource_group_name}"
  loadbalancer_id     = "${azurerm_lb.pg-master-lb.id}"
  protocol            = "HTTP"
  port                = 8008
  request_path        = "/replica"
}

resource "azurerm_lb_rule" "pg-master-postgres-rule" {
  name                = "postgres-rule"
  resource_group_name = "${var.resource_group_name}"
  loadbalancer_id     = "${azurerm_lb.pg-master-lb.id}"

  frontend_ip_configuration_name = "frontendip"
  protocol                       = "TCP"
  frontend_port                  = 5432
  backend_port                   = 5432

  backend_address_pool_id = "${azurerm_lb_backend_address_pool.pg-master-lb-backend-pool.id}"
  probe_id                = "${azurerm_lb_probe.pg-master-lb-probe.id}"
}

# loadbalancer to direct traffic to secondary nodes (read only)
resource "azurerm_public_ip" "pg-secondary-lb-public-ip" {
  name                = "pg-secondary-lb-public-ip"
  location            = "${var.location}"
  resource_group_name = "${var.resource_group_name}"
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_lb" "pg-secondary-lb" {
  name                = "${var.env_name}-pg-secondary-lb"
  location            = "${var.location}"
  resource_group_name = "${var.resource_group_name}"
  sku                 = "Standard"

  frontend_ip_configuration = {
    name                 = "frontendip"
    public_ip_address_id = "${azurerm_public_ip.pg-secondary-lb-public-ip.id}"
  }
}

resource "azurerm_lb_backend_address_pool" "pg-secondary-lb-backend-pool" {
  name                = "pg-secondary-lb-backend-pool"
  resource_group_name = "${var.resource_group_name}"
  loadbalancer_id     = "${azurerm_lb.pg-secondary-lb.id}"
}

resource "azurerm_lb_probe" "pg-secondary-lb-probe" {
  name                = "pg-secondary-lb-probe"
  resource_group_name = "${var.resource_group_name}"
  loadbalancer_id     = "${azurerm_lb.pg-secondary-lb.id}"
  protocol            = "HTTP"
  port                = 8008
  request_path        = "/master"
}

resource "azurerm_lb_rule" "pg-secondary-postgres-rule" {
  name                = "postgres-rule"
  resource_group_name = "${var.resource_group_name}"
  loadbalancer_id     = "${azurerm_lb.pg-secondary-lb.id}"

  frontend_ip_configuration_name = "frontendip"
  protocol                       = "TCP"
  frontend_port                  = 5432
  backend_port                   = 5432

  backend_address_pool_id = "${azurerm_lb_backend_address_pool.pg-secondary-lb-backend-pool.id}"
  probe_id                = "${azurerm_lb_probe.pg-secondary-lb-probe.id}"
}
