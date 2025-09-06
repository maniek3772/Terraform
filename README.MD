# Azure Infrastructure with Terraform

This project demonstrates how to configure infrastructure on **Microsoft
Azure** using **Terraform**.\
The environment consists of Linux virtual machines and a MySQL Flexible
Server database, deployed inside virtual networks and secured with
proper network rules.

------------------------------------------------------------------------

## Prerequisites

-   An active [Azure account](https://portal.azure.com/)

-   Installed
    [Terraform](https://developer.hashicorp.com/terraform/downloads)

-   Installed [Azure
    CLI](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli)

-   Logged into Azure subscription:

    ``` bash
    az login
    ```

------------------------------------------------------------------------

## Implementation Steps

1.  **Provider**
    -   Configure the `azurerm` provider with the required version and
        authentication.
2.  **Resource Group**
    -   Create a resource group using `azurerm_resource_group`.
3.  **Virtual Network and Subnets**
    -   `azurerm_virtual_network` -- main network for the
        infrastructure.
    -   `azurerm_subnet` -- subnets for virtual machines and for the
        database.
4.  **Database Subnet**
    -   A dedicated subnet for **MySQL Flexible Server**.
5.  **Network Security Group**
    -   `azurerm_network_security_group` with rules:
        -   Allow HTTP (80), HTTPS (443), and SSH (22) traffic to VMs.
        -   Allow traffic from the application subnet to the database
            subnet on port 3306.
6.  **Public IP and Network Interfaces**
    -   `azurerm_public_ip` -- assign public IPs for VMs.
    -   `azurerm_network_interface` -- configure NICs for the VMs.
7.  **Virtual Machines**
    -   `azurerm_linux_virtual_machine` -- create two Linux VMs.
    -   `custom_data` section -- install Python and pip.
    -   Configure firewall rules for VMs.
8.  **Database**
    -   `azurerm_mysql_flexible_server` -- deploy the MySQL server.
    -   `azurerm_mysql_flexible_database` -- create the database.
    -   `azurerm_mysql_flexible_server_firewall_rule` -- configure
        access rules.
9.  **Final Configuration**
    -   Ensure applications on VMs can query the database.
    -   Enable SSH access to VMs and application access via HTTP/HTTPS.

------------------------------------------------------------------------

##  Deployment

1.  Initialize Terraform:

    ``` bash
    terraform init
    ```

2.  Preview the execution plan:

    ``` bash
    terraform plan
    ```

3.  Deploy the infrastructure:

    ``` bash
    terraform apply
    ```

------------------------------------------------------------------------

##  Clean Up

To remove all resources, run:

``` bash
terraform destroy
```

------------------------------------------------------------------------

