# Route 53 ホストゾーン
data "aws_route53_zone" "primary" {
  name         = "playbass.uk."
  private_zone = false
}

# ACM 検証用 DNS レコード
resource "aws_route53_record" "acm_validation" {
  for_each = {
    for d in aws_acm_certificate.primary.domain_validation_options : d.domain_name => {
      name   = d.resource_record_name
      type   = d.resource_record_type
      record = d.resource_record_value
    }
  }

  zone_id = data.aws_route53_zone.primary.zone_id
  name    = each.value.name
  type    = each.value.type
  ttl     = 60
  records = [each.value.record]
  allow_overwrite = true
  
}


# ルートドメイン（playbass.uk）
resource "aws_route53_record" "root_domain" {
  zone_id = data.aws_route53_zone.primary.zone_id
  name    = "playbass.uk"
  type    = "A"

  alias {
    name                   = aws_lb.web_alb.dns_name
    zone_id                = aws_lb.web_alb.zone_id
    evaluate_target_health = true
  }
}

# www サブドメイン
resource "aws_route53_record" "www_domain" {
  zone_id = data.aws_route53_zone.primary.zone_id
  name    = "www.playbass.uk"
  type    = "A"

  alias {
    name                   = aws_lb.web_alb.dns_name
    zone_id                = aws_lb.web_alb.zone_id
    evaluate_target_health = true
  }
}