variable "project" { type = string }
variable "environment" { type = string }
variable "db_secret_name" { type = string }
variable "kms_key_alias" { type = string default = null }