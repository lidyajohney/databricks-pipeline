variable "region" {
    description = "Region in which the resources should be created"
    type = string
    default = "Canada Central"
}

variable "resource_group_name" {
    description = "Name of the resource group where to create the rest of the resources in"
    type = string
    default = "rg-opsguru-dlp"
}

variable "key_vault_name"{
    description = "Name of the keyvault to use which will store all the secrets"
    type = "string"
    default = "dlp-key-vault"
}
variable "service_principal_client_id"{
    description = "Client ID of the existing service principal that will used to communication between services"
    type = string
}

variable "service_principal_client_secret" {
    type =  string
    description = "Client secret of the existing service principal"
}

variable "service_principal_object_id"{
    description = "Object Id used by existing service to communicate_"
    type = string
}


variable "databricks_cluster_version"{
    description = "Runtime version of the Databricks cluster"
    type = string
    default = ""
}
variable "databricks_cluster_node_type" {
    description = string 
    type = string
    default = "Runtime: 7.5 (Spark 3.0.1, Scala 2.12)"
}

variable "databricks_min_workers"{
    description = "Minimum number of workers in active cluster"
    type = number 
    default = 1

}
variable "databricks_max_workers"{
    description = "Maximum number of workers in an active cluster"
    type = number
    default = 1
}
variable "databricks_workspace_name" {
     description = "Desired name for the ADB workspace"
     type = string
     default = "adb-lidya-dpl"
}

variable "data_lake_filesystems" {
  description = "A list of filesystems to create inside the storage account"
  type        = list(string)
  default     = ["raw", "transformed", "enriched", "aggregated", "golden"]
}

variable "dl_acl" {
  description = "Optional set of ACL to set on the filesystem roots inside the data lake. This is applied before dl_directories. The value is a map where the key is the name of the filesytem and the value is the ACL to set."
  type        = map(string)
  default     = {"raw":"r--","transformed":"r-w-","enriched":"r-w-","aggregated":"r-w-","golden":"-w-"}
}

variable "dl_directories" {
  description = "Optional root directories to be created inside the data lake. The value is a map where the keys are the names of the filesystems. The values are maps as well. In these nested maps, the keys are the names of the directories and the values are the ACL to set. Leave this empty to not set any ACL explicitly."
  type        = map(map(string))
  default     = {}
}

variable "data_lake_name" {
  description = "Name of the data lake (has to be globally unique)"
  type        = string
  default = "dlp_data"
}

variable "use_key_vault" {
  description = "Set this to true to enable the usage of your existing Key Vault"
  type        = bool
  default     = false
}

variable "autotermination_minutes"{
  description = "Number of idle minutes after which the cluster should Terminate"
  type = number
  default = 30

}