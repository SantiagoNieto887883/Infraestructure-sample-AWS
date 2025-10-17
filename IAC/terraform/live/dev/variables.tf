variable "project" { type = string }
variable "environment" { type = string }
variable "aws_region" { type = string }
variable "vpc_cidr" { type = string }
variable "public_subnets" { type = list(string) }
variable "private_subnets" { type = list(string) }
variable "allowed_cidrs" { type = list(string) }


# compute
variable "service_name" { type = string }
variable "container_port" { type = number }
variable "desired_count" { type = number }


# db
variable "db_engine" { type = string }
variable "db_min_capacity" { type = number }
variable "db_max_capacity" { type = number }


# flags
variable "enable_waf" { type = bool }
variable "enable_redis" { type = bool }

# ECR
variable "ecr_repo_name" { type = string }

# Secrets
variable "db_secret_name" { type = string }

# Opcional: KMS key alias para secretos
variable "kms_key_alias" { type = string default = null }