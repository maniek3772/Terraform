location                = "polandcentral"
environment             = "prod"
resource_group_location = "polandcentral"
network_name            = "prod-vnet"
vm_config = {
  "tfmaestro-web-app-01" = {
    private_ip          = "10.0.11.5"
    public_ip_name      = "tfmaestro-web-app-01 public IP"
    machine_type        = "Standard_B1s"
    machine_description = "Internal web application instance"
  }
  "tfmaestro-web-app-02" = {
    private_ip          = "10.0.11.4"
    public_ip_name      = "tfmaestro-web-app-02 public IP"
    machine_type        = "Standard_B1s"
    machine_description = "Internal web application instance"
  }
}

firewall_rules = {
  "allow-http" = {
    protocol              = "Tcp"
    ports                 = ["80"]
    priority              = 101
    description           = "Allow http communication."
    source_address_prefix = ["0.0.0.0/0"]
  }
  "allow-https" = {
    protocol              = "Tcp"
    ports                 = ["443"]
    priority              = 102
    description           = "Allow https communication."
    source_address_prefix = ["0.0.0.0/0"]
  }
  "allow-ssh-vpn" = {
    protocol              = "Tcp"
    ports                 = ["22"]
    priority              = 103
    description           = "Allow ssh communication via VPN."
    source_address_prefix = ["<YOUR_IP>/32"]
    }
  "allow-flask-app" = {
      protocol              = "Tcp"
      ports                 = ["8080"]
      priority              = 104
      description           = "Allow Flask app TCP communication on port 8080."
      source_address_prefix = ["0.0.0.0/0"]
    }
  "allow-mysql-tfmaestro-web-app-01" = {
    protocol              = "Tcp"
    ports                 = ["3306"]
    priority              = 105
    description           = "Allow MySQL traffic from tfmaestro-web-app-01 to the database."
    source_address_prefix = ["10.0.11.5/32"]
  }
  "allow-mysql-tfmaestro-web-app-02" = {
    protocol              = "Tcp"
    ports                 = ["3306"]
    priority              = 106
    description           = "Allow MySQL traffic from tfmaestro-web-app-02 to the database."
    source_address_prefix = ["10.0.11.4/32"]
  }
  "allow-icmp" = {
    protocol              = "Icmp"
    ports                 = []
    priority              = 2000
    description           = "Allow ICMP."
    source_address_prefix = ["0.0.0.0/0"]
  }
}
