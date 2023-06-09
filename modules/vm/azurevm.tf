# Create virtual network
resource "azurerm_virtual_network" "team2_terraform_network" {
  name                = var.vnname
  address_space       = ["10.0.0.0/16"]
  location            = var.location
  resource_group_name = var.rg_name
}

# Create subnet
resource "azurerm_subnet" "team2_terraform_subnet" {
  name                 = var.subnetid
  resource_group_name  = var.rg_name
  virtual_network_name = azurerm_virtual_network.team2_terraform_network.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Create public IPs
resource "azurerm_public_ip" "team2_terraform_public_ip" {
  name                = "team2PublicIP"
  location            = var.location
  resource_group_name = var.rg_name
  allocation_method   = "Dynamic"
}

# Create Network Security Group and rule
resource "azurerm_network_security_group" "team2_terraform_nsg" {
  name                = "team2NetworkSecurityGroup"
  location            = var.location
  resource_group_name = var.rg_name

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}


# Create network interface
resource "azurerm_network_interface" "team2_terraform_nic" {
  name                = "team2NIC"
  location            = var.location
  resource_group_name = var.rg_name

  ip_configuration {
    name                          = "team2_nic_configuration"
    subnet_id                     = azurerm_subnet.team2_terraform_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.team2_terraform_public_ip.id
  }
}

# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "sgconnectni" {
  network_interface_id      = azurerm_network_interface.team2_terraform_nic.id
  network_security_group_id = azurerm_network_security_group.team2_terraform_nsg.id
}


# Create virtual machine
resource "azurerm_linux_virtual_machine" "team2_terraform_vm" {
  name                  = "${var.vm_name}${random_string.suffix.result}"
  location            = var.location
  resource_group_name = var.rg_name
  network_interface_ids = [azurerm_network_interface.team2_terraform_nic.id]
  size                  = "Standard_DS1_v2"

  os_disk {
    name                 = "myOsDisk"
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }
  computer_name                   = "team2vm"
  admin_username                  = var.user_name
  disable_password_authentication = true

  admin_ssh_key {
    username   = "azureuser"
    public_key = var.public_key
  }

  boot_diagnostics {
    storage_account_uri = ""
  }
}



resource "random_string" "suffix" {  
length = 4
upper = false
special = false
}