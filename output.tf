output "EC2_Public_IPs" {
  description = "EC2 Public IP"
  value = aws_instance.multi.*.public_ip
}
output "ALB_URL" {
  description = "URL of ALB"
  value       = "http://${aws_lb.web_alb.dns_name}"
}

output "deploy_bucket_name" {
  value = aws_s3_bucket.deploy_bucket.id
}

output "Site_URL" {
  description = "URL of the Site"
  value       = "https://playbass.uk"
}

