# SSL/TLS 証明書（playbass.uk）
resource "aws_acm_certificate" "primary" {
  domain_name       = "playbass.uk"
  validation_method = "DNS"
  subject_alternative_names = [
    "*.playbass.uk"
  ]
  key_algorithm = "RSA_2048"

  lifecycle {
    create_before_destroy = true
  }
}


# 証明書検証（DNS）
resource "aws_acm_certificate_validation" "primary" {
  certificate_arn         = aws_acm_certificate.primary.arn
  validation_record_fqdns = [for record in aws_route53_record.acm_validation : record.fqdn]
}