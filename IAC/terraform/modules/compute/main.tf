resource "aws_ecs_cluster" "this" {
protocol = "HTTP"
vpc_id = var.vpc_id
health_check { path = "/health" matcher = "200-399" }
}

resource "aws_lb" "alb" {
name = "${var.project}-${var.environment}-alb"
internal = false
load_balancer_type = "application"
security_groups = [var.alb_sg_id]
subnets = var.public_subnets
}


resource "aws_lb_target_group" "tg" {
name = "${var.project}-${var.environment}-tg"
port = var.container_port
protocol = "HTTP"
vpc_id = var.vpc_id
health_check { path = "/health" matcher = "200-399" }
}

resource "aws_lb_listener" "http" {
load_balancer_arn = aws_lb.alb.arn
port = 80
protocol = "HTTP"
default_action { type = "forward" target_group_arn = aws_lb_target_group.tg.arn }
}


resource "aws_ecs_task_definition" "task" {
family = "${var.project}-${var.environment}-${var.service_name}"
requires_compatibilities = ["FARGATE"]
network_mode = "awsvpc"
cpu = 512
memory = 1024
execution_role_arn = null # TODO: define IAM
task_role_arn = null # TODO: define IAM


container_definitions = jsonencode([
{
name = var.service_name
image = var.container_image
essential = true
portMappings = [{ containerPort = var.container_port, hostPort = var.container_port }]
environment = [
{ name = "DB_SECRET_ARN", value = var.db_secret_arn }
]
logConfiguration = {
logDriver = "awslogs"
options = {
awslogs-create-group = "true"
awslogs-group = "/ecs/${var.project}-${var.environment}"
awslogs-region = "${var.aws_region}" # si agregas var
awslogs-stream-prefix = var.service_name
}
}
}
])
}


resource "aws_ecs_service" "svc" {
name = "${var.project}-${var.environment}-${var.service_name}"
cluster = aws_ecs_cluster.this.id
task_definition = aws_ecs_task_definition.task.arn
desired_count = var.desired_count
launch_type = "FARGATE"


network_configuration {
subnets = var.private_subnets
security_groups = [var.ecs_sg_id]
assign_public_ip = false
}


load_balancer {
target_group_arn = aws_lb_target_group.tg.arn
container_name = var.service_name
container_port = var.container_port
}
}