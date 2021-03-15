resource "azurerm_key_vault_access_policy" "df" {
  count              = local.use_kv
  key_vault_id       = var.key_vault_name
  tenant_id          = azurerm_data_factory.df.identity[0].tenant_id
  object_id          = azurerm_data_factory.df.identity[0].principal_id
  secret_permissions = ["list", "get"]
}

resource "azurerm_key_vault_secret" "databricks_token" {
  count        = var.use_key_vault && local.create_databricks_bool ? 1 : 0
  name         = "databricks-access-token"
  value        = databricks_token.token[count.index].token_value
  key_vault_id = var.key_vault_id
  tags         = local.own_tags
}

resource "azurerm_key_vault_secret" "storage_key" {
  count        = local.use_kv
  name         = "dl-storage-key"
  value        = azurerm_storage_account.adls.primary_access_key
  key_vault_id = var.key_vault_id
  tags         = local.own_tags
}



