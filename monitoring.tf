# monitoring.tf

# 1. EC2 CPU使用率アラーム（無料）
resource "aws_cloudwatch_metric_alarm" "ec2_cpu_high" {
  alarm_name          = "ec2-cpu-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "300"
  statistic           = "Average"
  threshold           = "80"
  alarm_description   = "EC2 CPU usage exceeds 80%"
  
  dimensions = {
    InstanceId = aws_instance.multi.id
  }
}

# 2. ALB Target Health（無料）
resource "aws_cloudwatch_metric_alarm" "alb_unhealthy_hosts" {
  alarm_name          = "alb-unhealthy-hosts"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "UnHealthyHostCount"
  namespace           = "AWS/ApplicationELB"
  period              = "300"
  statistic           = "Average"
  threshold           = "0"
  
  dimensions = {
    LoadBalancer = aws_lb.web_alb.arn_suffix
    TargetGroup  = aws_lb_target_group.web_tg.arn_suffix
  }
}

# 3. CloudWatch Log Group（データ量次第で無料）
resource "aws_cloudwatch_log_group" "user_data_logs" {
  name              = "/aws/ec2/user-data"
  retention_in_days = 7  # 短期保存でコスト削減
}