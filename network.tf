resource "azurerm_virtual_network" "pavv3" {
  name                = var.vnet_details.name
  resource_group_name = var.resourcegroup_details.name
  location            = var.resourcegroup_details.location
  address_space       = var.vnet_details.address_space
     depends_on = [
      azurerm_resource_group.srii5
     ]
}  
resource "azurerm_subnet" "subnets" {
  name                 = var.subnet_details.names[count.index]
   count = length(var.subnet_details.names)
  resource_group_name  =  var.resourcegroup_details.name
  virtual_network_name =  var.vnet_details.name
   address_prefixes = [ cidrsubnet(var.vnet_details.address_space[0],8,count.index)]
    depends_on = [
        azurerm_resource_group.srii5,
        azurerm_virtual_network.pavv3,
    ]
}
resource "azurerm_network_security_group" "security_grp" {
  name                = "security"
  location            =  var.resourcegroup_details.location
  resource_group_name =  var.resourcegroup_details.name

  security_rule {
    name                       = "openssh"
    priority                   = 300
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "openhttp"
    priority                   = 310
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  
  depends_on = [
    azurerm_resource_group.srii5
  ]
}
resource "azurerm_public_ip" "ps4" {
  name                = "pav"
  resource_group_name =  var.resourcegroup_details.name
  location            =  var.resourcegroup_details.location
  allocation_method   = "Dynamic"
  depends_on = [
    azurerm_resource_group.srii5
  ]
}

resource "azurerm_network_interface" "network_interface" {
  name                = "nic"
  location            =  var.resourcegroup_details.location
  resource_group_name =  var.resourcegroup_details.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnets[0].id
    private_ip_address_allocation = "Dynamic"
      public_ip_address_id          = azurerm_public_ip.ps4.id
  }
    depends_on = [
    azurerm_subnet.subnets,
    azurerm_public_ip.ps4
  ]
}
resource "azurerm_network_interface_security_group_association" "example" {
  network_interface_id      = azurerm_network_interface.network_interface.id
  network_security_group_id = azurerm_network_security_group.security_grp.id
  depends_on = [
    azurerm_network_security_group.security_grp,
    azurerm_network_interface.network_interface
  ]
}


