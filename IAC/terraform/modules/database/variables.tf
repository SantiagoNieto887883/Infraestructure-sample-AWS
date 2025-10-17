variable "project" { type = string }
variable "environment" { type = string }
variable "vpc_id" { type = string }
variable "db_subnet_ids" { type = list(string) }
variable "db_engine" { type = string }
variable "min_capacity" { type = number }
variable "max_capacity" { type = number }
variable "db_sg_id" { type = string }