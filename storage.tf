resource "azurerm_storage_account" "adls"{
    name = "storageacc ${var.data_lake_name}"
    location = var.region
    resource_group_name = var.resource_group_name
    account_tier = "Standard"
    access_tier = "Cool"
    tags = local.common_tags
}

resource "azurerm_role_assignment" "dlp_sa_adls"{
    scope = azurerm_storage_account.adls.id 
    role_definition_name = "Storage Blob Data Owner"
    principal_id = var.service_principal_object_id

}

resource "azurerm_role_assignment" "dlp_user_sa_adls"{
    scope = azurerm_storage_account.adls.id
    role_definition_name = "Storage Blob Data Owner"
    principal_id = data.azurerm_client_config.current.object_id
}

resource "azurerm_storage_data_lake_gen2_filesystem" "dlp_adls_filesystem"{
    for_each = toset(var.data_lake_filesystems)
    name = each.key
    storage_account_id = azurerm_storage_account.adls.id
    depends_on =[azurerm_role_assignment.dlp_user_sa_adls]
}

resource "local_file" "storageacc_set_acl"{
    content = templatefile("${path.module}/files/sa_acl.sh",{
        "filesystems" = keys(var.dl_acl)
    })
    filename = "/tmp/set_acl.sh"
}

resource "null_resource" "storageacc_set_acl" {
    depends_on = [azurerm_role_assignment.dlp_user_sa_adls,azurerm_storage_data_lake_gen2_filesystem.dlp_adls_filesystem]
    triggers = {
        "acl" = local_file.storageacc_set_acl.content
    }

    provisioner "local-exec" {
        command = local_file.storageacc_set_acl.filename
        environment = {
            "AZURE_STORAGE_KEY" = azurerm_storage_account.adls.primary_access_key
            "AZURE_STORAGE_ACCOUNT" = azurerm_storage_account.adls.name
            "AZURE_STORAGE_AUTH_MODE" = "key"
        }
    
    }
  
}

resource "local_file" "sa_create_directories" {
  content = templatefile("${path.module}/files/sa_directories.sh", {
    "filesystems"  = keys(var.dl_directories)
    "fs_dirs_acls" = var.dl_directories
  })
  filename = "/tmp/create_directories.sh"
}

resource "null_resource" "sa_create_directories" {
  depends_on = [null_resource.storageacc_set_acl, azurerm_role_assignment.dlp_user_sa_adls, azurerm_storage_data_lake_gen2_filesystem.dlp_adls_filesystem]
  triggers = {
    "directories" = local_file.sa_create_directories.content
  }

  provisioner "local-exec" {
    command = local_file.sa_create_directories.filename
    environment = {
      "AZURE_STORAGE_KEY"       = azurerm_storage_account.adls.primary_access_key
      "AZURE_STORAGE_ACCOUNT"   = azurerm_storage_account.adls.name
      "AZURE_STORAGE_AUTH_MODE" = "key"
    }
  }
}

