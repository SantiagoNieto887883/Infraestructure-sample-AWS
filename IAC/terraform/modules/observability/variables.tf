variable "project" { type = string }
variable "environment" { type = string }
variable "alb_arn" { type = string }
variable "ecs_service_arn" { type = string }
variable "enable_waf" { type = bool }