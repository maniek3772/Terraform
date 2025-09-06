environment = "prod"
firewall_rules = {
  "allow-vpn" = {
    start_ip_address = "<YOUR_IP>"
    end_ip_address   = "<YOUR_IP>"
  }
  "allow-server-public" = {
    start_ip_address = "74.248.128.227"
    end_ip_address   = "74.248.146.247"
  }
  "allow-server-private" = {
    start_ip_address = "10.0.11.4"
    end_ip_address   = "10.0.11.5"
  }
}