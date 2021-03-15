output "name"{
    description = "Name of the data lake storage created"
    value = var.data_lake_name
}

output "created_key_vault_secrets" {
  description = "Secrets that have been created inside the optional Key Vault with their versions"
  value       = local.created_secrets_all
}

output "storage_dfs_endpoint" {
  description = "Primary DFS endpoint of the created storage account"
  value       = azurerm_storage_account.adls.primary_dfs_endpoint
}

output "storage_account_name" {
  description = "Name of the created storage account for ADLS"
  value       = azurerm_storage_account.adls.name
}