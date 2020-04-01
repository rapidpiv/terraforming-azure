resource "azurerm_public_ip" "pg-leader-lb-public-ip" {
  name                = "pg-leader-lb-public-ip"
  location            = "${var.location}"
  resource_group_name = "${var.resource_group_name}"
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_lb" "pg-leader-lb" {
  name                = "${var.env_name}-pg-leader-lb"
  location            = "${var.location}"
  resource_group_name = "${var.resource_group_name}"
  sku                 = "Standard"

  frontend_ip_configuration = {
    name                 = "frontendip"
    public_ip_address_id = "${azurerm_public_ip.pg-leader-lb-public-ip.id}"
  }
}

resource "azurerm_lb_backend_address_pool" "pg-leader-lb-backend-pool" {
  name                = "pg-leader-lb-backend-pool"
  resource_group_name = "${var.resource_group_name}"
  loadbalancer_id     = "${azurerm_lb.pg-leader-lb.id}"
}

resource "azurerm_lb_probe" "pg-leader-lb-probe" {
  name                = "pg-leader-lb-probe"
  resource_group_name = "${var.resource_group_name}"
  loadbalancer_id     = "${azurerm_lb.pg-leader-lb.id}"
  protocol            = "HTTP"
  port                = 8008
  request_path        = "/master"
}

resource "azurerm_lb_rule" "postgres-rule" {
  name                = "postgres-rule"
  resource_group_name = "${var.resource_group_name}"
  loadbalancer_id     = "${azurerm_lb.pg-leader-lb.id}"

  frontend_ip_configuration_name = "frontendip"
  protocol                       = "TCP"
  frontend_port                  = 5432
  backend_port                   = 5432

  backend_address_pool_id = "${azurerm_lb_backend_address_pool.pg-leader-lb-backend-pool.id}"
  probe_id                = "${azurerm_lb_probe.pg-leader-lb-probe.id}"
}
