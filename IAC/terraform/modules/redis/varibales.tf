variable "project"        { type = string }
variable "environment"     { type = string }
variable "vpc_id"          { type = string }
variable "subnet_ids"      { type = list(string) }
variable "security_group_id" { type = string }
variable "node_type"       { type = string default = "cache.t3.medium" }
variable "engine_version"  { type = string default = "7.1" }
variable "num_cache_nodes" { type = number default = 1 }
variable "auth_token"      { type = string default = null }