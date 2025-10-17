variable "project" { type = string }
variable "environment" { type = string }
variable "vpc_id" { type = string }
variable "alb_subnet_ids" { type = list(string) }
variable "ecs_subnet_ids" { type = list(string) }
variable "db_subnet_ids" { type = list(string) }
variable "container_port" { type = number }