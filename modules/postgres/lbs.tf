resource "azurerm_public_ip" "pg-lb-rw-public-ip" {
  name                = "pg-lb-rw-public-ip"
  location            = "${var.location}"
  resource_group_name = "${var.resource_group_name}"
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_dns_a_record" "pg_lb_rw_dns_a_rec" {
  name                = "pgrw"
  zone_name           = "${var.dns_zone_name}"
  resource_group_name = "${var.resource_group_name}"
  ttl                 = "60"
  records             = ["${azurerm_public_ip.pg-lb-rw-public-ip.ip_address}"]
}

 resource "azurerm_public_ip" "pg-lb-ro-public-ip" {
   name                = "pg-lb-ro-public-ip"
   location            = "${var.location}"
   resource_group_name = "${var.resource_group_name}"
   allocation_method   = "Static"
   sku                 = "Standard"
 }

resource "azurerm_dns_a_record" "pg_lb_ro_dns_a_rec" {
  name                = "pgro"
  zone_name           = "${var.dns_zone_name}"
  resource_group_name = "${var.resource_group_name}"
  ttl                 = "60"
  records             = ["${azurerm_public_ip.pg-lb-ro-public-ip.ip_address}"]
}

resource "azurerm_lb" "pg-lb" {
  name                = "${var.env_name}-pg-lb"
  location            = "${var.location}"
  resource_group_name = "${var.resource_group_name}"
  sku                 = "Standard"

  frontend_ip_configuration = {
    name                 = "read-write"
    public_ip_address_id = "${azurerm_public_ip.pg-lb-rw-public-ip.id}"
  }

  frontend_ip_configuration = {
    name                 = "read-only"
    public_ip_address_id = "${azurerm_public_ip.pg-lb-ro-public-ip.id}"
  }
}

resource "azurerm_lb_backend_address_pool" "pg-lb-rw-backend-pool" {
  name                = "pg-lb-rw-backend-pool"
  resource_group_name = "${var.resource_group_name}"
  loadbalancer_id     = "${azurerm_lb.pg-lb.id}"
}

resource "azurerm_lb_backend_address_pool" "pg-lb-ro-backend-pool" {
  name                = "pg-lb-ro-backend-pool"
  resource_group_name = "${var.resource_group_name}"
  loadbalancer_id     = "${azurerm_lb.pg-lb.id}"
}

resource "azurerm_lb_probe" "pg-lb-rw-probe" {
  name                = "pg-lb-rw-probe"
  resource_group_name = "${var.resource_group_name}"
  loadbalancer_id     = "${azurerm_lb.pg-lb.id}"
  protocol            = "HTTP"
  port                = 8008
  request_path        = "/master"
}

resource "azurerm_lb_probe" "pg-lb-ro-probe" {
  name                = "pg-lb-ro-probe"
  resource_group_name = "${var.resource_group_name}"
  loadbalancer_id     = "${azurerm_lb.pg-lb.id}"
  protocol            = "HTTP"
  port                = 8008
  request_path        = "/replica"
}

resource "azurerm_lb_rule" "pg-lb-rw-postgres-rule" {
  name                = "pg-lb-rw-postgres-rule"
  resource_group_name = "${var.resource_group_name}"
  loadbalancer_id     = "${azurerm_lb.pg-lb.id}"

  frontend_ip_configuration_name = "read-write"
  protocol                       = "TCP"
  frontend_port                  = 5432
  backend_port                   = 5432

  backend_address_pool_id = "${azurerm_lb_backend_address_pool.pg-lb-rw-backend-pool.id}"
  probe_id                = "${azurerm_lb_probe.pg-lb-rw-probe.id}"
}

resource "azurerm_lb_rule" "pg-lb-ro-postgres-rule" {
  name                = "pg-lb-ro-postgres-rule"
  resource_group_name = "${var.resource_group_name}"
  loadbalancer_id     = "${azurerm_lb.pg-lb.id}"

  frontend_ip_configuration_name = "read-only"
  protocol                       = "TCP"
  frontend_port                  = 5432
  backend_port                   = 5432

  backend_address_pool_id = "${azurerm_lb_backend_address_pool.pg-lb-ro-backend-pool.id}"
  probe_id                = "${azurerm_lb_probe.pg-lb-ro-probe.id}"
}
