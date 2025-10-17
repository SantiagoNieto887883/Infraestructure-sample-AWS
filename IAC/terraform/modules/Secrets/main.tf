locals {
name = var.db_secret_name != null && length(var.db_secret_name) > 0 ? var.db_secret_name : "${var.project}/${var.environment}/db"
}


resource "aws_kms_key" "this" {
count = var.kms_key_alias == null ? 0 : 1
description = "KMS for secrets ${var.project}-${var.environment}"
deletion_window_in_days = 7
}


resource "aws_kms_alias" "this" {
count = var.kms_key_alias == null ? 0 : 1
name = "alias/${var.kms_key_alias}"
target_key_id = aws_kms_key.this[0].key_id
}

resource "aws_secretsmanager_secret" "db" {
name = local.name
kms_key_id = var.kms_key_alias == null ? null : aws_kms_key.this[0].arn
}


resource "aws_secretsmanager_secret_version" "db" {
secret_id = aws_secretsmanager_secret.db.id
secret_string = jsonencode({
username = "app",
password = "ChangeMe123!",
host = "",
port = 3306,
dbname = "appdb"
})
}