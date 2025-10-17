locals {
  name = "${var.project}-${var.environment}-redis"
}

resource "aws_elasticache_subnet_group" "this" {
  name       = "${local.name}-subnet-group"
  subnet_ids = var.subnet_ids
}

resource "aws_elasticache_parameter_group" "this" {
  name   = "${local.name}-params"
  family = "redis7"
  description = "Redis parameter group for ${local.name}"
}

resource "aws_elasticache_replication_group" "this" {
  replication_group_id          = local.name
  replication_group_description = "Redis for ${var.project}-${var.environment}"
  engine                        = "redis"
  engine_version                = var.engine_version
  node_type                     = var.node_type
  num_cache_clusters             = var.num_cache_nodes
  parameter_group_name          = aws_elasticache_parameter_group.this.name
  subnet_group_name             = aws_elasticache_subnet_group.this.name
  security_group_ids            = [var.security_group_id]
  at_rest_encryption_enabled    = true
  transit_encryption_enabled    = true

  automatic_failover_enabled = var.num_cache_nodes > 1 ? true : false
  auth_token = var.auth_token

  tags = {
    Project     = var.project
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}