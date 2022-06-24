output "cosmosdb_connectionstrings" {
  value     = azurerm_cosmosdb_account.db.connection_strings
  sensitive = true
}
