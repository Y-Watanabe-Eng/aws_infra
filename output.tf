output "EC2_Public_IPs" {
  description = "EC2 Public IP"
  value = aws_instance.multi.*.public_ip
}
output "ALB_DNS_Name" {
  description = "Application Load Balancer DNS Name"
  value       = aws_lb.web_alb.dns_name
}