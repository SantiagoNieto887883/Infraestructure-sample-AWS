output "alb_arn" { value = aws_lb.alb.arn }
output "alb_dns_name" { value = aws_lb.alb.dns_name }
output "ecs_service_arn" { value = aws_ecs_service.svc.arn }