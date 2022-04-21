resource "aws_route53_zone" "hosted_zone" {
  name = var.hosted_zone

  # Required for Private Hosted Zone (PHZ)
  vpc {
    vpc_id = data.aws_vpc.main_vpc.id
  }
}

resource "aws_route53_record" "cname_example" {
  zone_id = aws_route53_zone.hosted_zone.zone_id
  name    = "${var.subdomain}.${var.hosted_zone}"
  type    = "CNAME"
  ttl     = "300"
  records = [aws_lb.application_lb.dns_name]
}

resource "aws_route53_record" "alias_route53_record" {
  zone_id = aws_route53_zone.hosted_zone.zone_id # Replace with your zone ID
  name    = var.hosted_zone                          # Replace with your name/domain/subdomain
  type    = "A"

  alias {
    name                   = aws_lb.application_lb.dns_name
    zone_id                = aws_lb.application_lb.zone_id
    evaluate_target_health = true
  }
}