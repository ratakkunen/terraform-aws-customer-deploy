resource "aws_route53_zone" "main" {
  name          = "${var.service_dns_zone_name}"
  vpc {
    vpc_id    = "${var.vpc_id}"
  }
  force_destroy = true
}
