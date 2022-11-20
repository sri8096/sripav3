resource "azurerm_mssql_server" "hiii" {
  name                         = "hlo"
  resource_group_name          = var.resourcegroup_details.name
  location                     = var.resourcegroup_details.location
  version                      = "12.0"
  administrator_login          = "asus"
  administrator_login_password = "Srikanth@123"
    depends_on = [
        azurerm_virtual_network.pavv3,
      azurerm_subnet.subnets
    ]

}
resource "azurerm_mssql_database" "mssqldb" {
    name = "dbsp"
    server_id = azurerm_mssql_server.hiii.id
    sample_name = "AdventureWorksLT"
    sku_name = "Basic"
    depends_on = [
      azurerm_mssql_server.hiii
    ]
}
