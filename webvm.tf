 resource "azurerm_linux_virtual_machine" "vm" {
  name                = "web"
  resource_group_name =  var.resourcegroup_details.name
  location            = var.resourcegroup_details.location
  size                = "Standard_B1s"
  admin_username      = "asus"
    admin_password = "Srikanth@123"
  network_interface_ids = [
    azurerm_network_interface.network_interface.id,
  ]
 disable_password_authentication = false
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
}
    resource "null_resource" "hlos" {
  triggers = {
    version = var.runningversion
  }
  provisioner "remote-exec" {
    inline = [
      "sudo apt update",
      "sudo apt install nginx -y"
    ]

    connection {
     host = azurerm_linux_virtual_machine.vm.public_ip_address
     user = "asus"
     password = "Srikanth@123"

    }
  }

  depends_on = [
    azurerm_linux_virtual_machine.vm
  ]
}

