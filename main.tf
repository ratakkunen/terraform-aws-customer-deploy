resource "random_string" "rand_hostname" {
  length  = 8
  special = false
  upper   = false
}

locals {
  s3_interfaces_bucket = "${var.customer_name}-interfaces-${random_string.rand_hostname.result}.idscloud"
}

locals {
s3_origination_bucket = "${var.customer_name}-origination-${random_string.rand_hostname.result}.idscloud"
}

locals {
  s3_insurance_bucket = "${var.customer_name}-insurance-${random_string.rand_hostname.result}.idscloud"
}

locals {
  s3_bank_bucket = "${var.customer_name}-bank-${random_string.rand_hostname.result}.idscloud"
}
