data "aws_route53_zone" "selected" {
  name         = "${var.private_service_dns_zone_name}"
  private_zone = true
}
