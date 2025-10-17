# Ejemplo mínimo con Aurora MySQL Serverless v2
resource "aws_rds_subnet_group" "this" {
name = "${var.project}-${var.environment}-db-subnets"
subnet_ids = var.db_subnet_ids
}


resource "aws_rds_cluster" "this" {
cluster_identifier = "${var.project}-${var.environment}-aurora"
engine = var.db_engine # "aurora-mysql"
engine_mode = "provisioned" # Serverless v2 usa provisioned
db_subnet_group_name = aws_rds_subnet_group.this.name
vpc_security_group_ids = [var.db_sg_id]
storage_encrypted = true
backup_retention_period = 7
deletion_protection = false
master_username = "admin"
master_password = "changeme123!" # TODO: Secrets Manager
scaling_configuration { min_capacity = var.min_capacity max_capacity = var.max_capacity }
}


resource "aws_rds_cluster_instance" "this" {
count = 2
identifier = "${var.project}-${var.environment}-aurora-${count.index}"
cluster_identifier = aws_rds_cluster.this.id
instance_class = "db.serverless"
engine = var.db_engine
}