output "key_vault" {
  value = azurerm_key_vault.keyvault.name
}

output "cosmos_secret" {
  value = azurerm_key_vault_secret.secret.name
}
