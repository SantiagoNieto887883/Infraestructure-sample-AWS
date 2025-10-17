locals {
name = "${var.project}-${var.environment}"
}


resource "aws_iam_role" "execution" {
name = "${local.name}-ecs-execution"
assume_role_policy = jsonencode({
Version = "2012-10-17"
Statement = [{
Effect = "Allow"
Principal = { Service = "ecs-tasks.amazonaws.com" }
Action = "sts:AssumeRole"
}]
})
}

resource "aws_iam_role_policy_attachment" "execution_basic" {
role = aws_iam_role.execution.name
policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}


# Acceso a Secrets Manager para PULL de secretos en start
resource "aws_iam_policy" "execution_secrets" {
name = "${local.name}-exec-secrets"
description = "Allow GetSecretValue and Decrypt"
policy = jsonencode({
Version = "2012-10-17",
Statement = [
{
Effect = "Allow",
Action = ["secretsmanager:GetSecretValue"],
Resource = "*"
},
{
Effect = "Allow",
Action = ["kms:Decrypt"],
Resource = "*"
}
]
})
}

resource "aws_iam_role_policy_attachment" "execution_secrets_attach" {
role = aws_iam_role.execution.name
policy_arn = aws_iam_policy.execution_secrets.arn
}


resource "aws_iam_role" "task" {
name = "${local.name}-ecs-task"
assume_role_policy = jsonencode({
Version = "2012-10-17"
Statement = [{
Effect = "Allow",
Principal = { Service = "ecs-tasks.amazonaws.com" },
Action = "sts:AssumeRole"
}]
})
}

# Permisos de la app (mínimos, ajusta a tu caso)
resource "aws_iam_policy" "task_app" {
name = "${local.name}-task-app"
policy = jsonencode({
Version = "2012-10-17",
Statement = [
{ Effect = "Allow", Action = ["logs:CreateLogStream","logs:PutLogEvents"], Resource = "*" },
{ Effect = "Allow", Action = ["secretsmanager:GetSecretValue"], Resource = "*" },
{ Effect = "Allow", Action = ["kms:Decrypt"], Resource = "*" }
]
})
}


resource "aws_iam_role_policy_attachment" "task_app_attach" {
role = aws_iam_role.task.name
policy_arn = aws_iam_policy.task_app.arn
}