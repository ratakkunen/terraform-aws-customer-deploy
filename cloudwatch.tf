resource "aws_cloudwatch_log_group" "infolease" {
  name = "${var.customer_name}/infolease"

  retention_in_days = "${var.log_retention_days_infolease}"

  # TODO: kms_key_id

  tags {
    terraform = "true"
    Customer  = "${var.customer_name}"
  }
}

resource "aws_cloudwatch_log_group" "reporting" {
  name = "${var.customer_name}/reporting"

  retention_in_days = "${var.log_retention_days_reporting}"

  # TODO: kms_key_id

  tags {
    terraform = "true"
    Customer  = "${var.customer_name}"
  }
}
