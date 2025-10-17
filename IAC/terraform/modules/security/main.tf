resource "aws_security_group" "alb" {
name = "${var.project}-${var.environment}-alb-sg"
description = "ALB ingress"
vpc_id = var.vpc_id


ingress { from_port = 80 to_port = 80 protocol = "tcp" cidr_blocks = ["0.0.0.0/0"] }
ingress { from_port = 443 to_port = 443 protocol = "tcp" cidr_blocks = ["0.0.0.0/0"] }
egress { from_port = 0 to_port = 0 protocol = "-1" cidr_blocks = ["0.0.0.0/0"] }
}


resource "aws_security_group" "ecs" {
name = "${var.project}-${var.environment}-ecs-sg"
vpc_id = var.vpc_id


ingress { from_port = var.container_port to_port = var.container_port protocol = "tcp" security_groups = [aws_security_group.alb.id] }
egress { from_port = 0 to_port = 0 protocol = "-1" cidr_blocks = ["0.0.0.0/0"] }
}


resource "aws_security_group" "db" {
name = "${var.project}-${var.environment}-db-sg"
vpc_id = var.vpc_id


ingress { from_port = 3306 to_port = 3306 protocol = "tcp" security_groups = [aws_security_group.ecs.id] }
egress { from_port = 0 to_port = 0 protocol = "-1" cidr_blocks = ["0.0.0.0/0"] }
}

resource "aws_security_group" "redis" {
  name   = "${var.project}-${var.environment}-redis-sg"
  vpc_id = var.vpc_id

  ingress {
    from_port       = 6379
    to_port         = 6379
    protocol        = "tcp"
    security_groups = [aws_security_group.ecs.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}