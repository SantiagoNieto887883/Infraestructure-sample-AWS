# alarmas (completar según tus métricas)
resource "aws_cloudwatch_metric_alarm" "alb_5xx" {
alarm_name = "${var.project}-${var.environment}-alb-5xx"
namespace = "AWS/ApplicationELB"
metric_name = "HTTPCode_ELB_5XX_Count"
statistic = "Sum"
period = 60
evaluation_periods = 5
threshold = 10
comparison_operator = "GreaterThanOrEqualToThreshold"
dimensions = {
LoadBalancer = split("/", var.alb_arn)[1]
}
}