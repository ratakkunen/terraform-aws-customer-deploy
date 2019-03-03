output "aws_route53_private_zone_id" {
  value = "${aws_route53_zone.main.zone_id}"
}

output "customer_bucket" {
  value = "${local.s3_interfaces_bucket}"
}

output "origination_bucket" {
  value = "${local.s3_origination_bucket}"
}

output "insurance_bucket" {
  value = "${local.s3_insurance_bucket}"
}

output "bank_bucket" {
  value = "${local.s3_bank_bucket}"
}
