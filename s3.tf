data "template_file" "s3_interfaces_policy" {
  template = "${file("include/interfaces_bucket_policy.tpl")}"

  vars {
    account_id                     = "${data.aws_caller_identity.current.account_id}"
    namespace                      = "${var.namespace}"
    environment_name               = "${var.environment}"
    s3_interfaces_bucket           = "${local.s3_interfaces_bucket}"
  }
}

module "customer_s3_bucket" {
  source                 = "git::https://github.com/IDS-Inc/terraform-aws-s3-bucket.git?ref=master"
  name                   = "${local.s3_interfaces_bucket}"
  stage                  = "${var.environment}"
  namespace              = "${var.namespace}"
  policy                 = "${data.template_file.s3_interfaces_policy.rendered}"
  force_destroy          = "true"
  versioning_enabled     = "true"
  sse_algorithm          = "aws:kms"
  version_retention_days = "365"
  log_retention_days     = "365"                                 # 1 year
}

data "template_file" "s3_origination_policy" {
  template = "${file("include/origination_bucket_policy.tpl")}"

  vars {
    account_id                     = "${data.aws_caller_identity.current.account_id}"
    namespace                      = "${var.namespace}"
    environment_name               = "${var.environment}"
    s3_origination_bucket          = "${local.s3_origination_bucket}"
  }
}

module "origination_s3_bucket" {
  source                 = "git::https://github.com/IDS-Inc/terraform-aws-s3-bucket.git?ref=master"
  name                   = "${local.s3_origination_bucket}"
  stage                  = "${var.environment}"
  namespace              = "${var.namespace}"
  policy                 = "${data.template_file.s3_origination_policy.rendered}"
  force_destroy          = "true"
  versioning_enabled     = "true"
  sse_algorithm          = "aws:kms"
  version_retention_days = "365"
  log_retention_days     = "365"                                 # 1 year
}

data "template_file" "s3_insurance_policy" {
  template = "${file("include/insurance_bucket_policy.tpl")}"

  vars {
    account_id                     = "${data.aws_caller_identity.current.account_id}"
    namespace                      = "${var.namespace}"
    environment_name               = "${var.environment}"
    s3_insurance_bucket            = "${local.s3_insurance_bucket}"
  }
}

module "insurance_s3_bucket" {
  source                 = "git::https://github.com/IDS-Inc/terraform-aws-s3-bucket.git?ref=master"
  name                   = "${local.s3_insurance_bucket}"
  stage                  = "${var.environment}"
  namespace              = "${var.namespace}"
  policy                 = "${data.template_file.s3_insurance_policy.rendered}"
  force_destroy          = "true"
  versioning_enabled     = "true"
  sse_algorithm          = "aws:kms"
  version_retention_days = "365"
  log_retention_days     = "365"                                 # 1 year
}

data "template_file" "s3_bank_policy" {
  template = "${file("include/bank_bucket_policy.tpl")}"

  vars {
    account_id                     = "${data.aws_caller_identity.current.account_id}"
    namespace                      = "${var.namespace}"
    environment_name               = "${var.environment}"
    s3_bank_bucket                 = "${local.s3_bank_bucket}"
  }
}

module "bank_s3_bucket" {
  source                 = "git::https://github.com/IDS-Inc/terraform-aws-s3-bucket.git?ref=master"
  name                   = "${local.s3_bank_bucket}"
  stage                  = "${var.environment}"
  namespace              = "${var.namespace}"
  policy                 = "${data.template_file.s3_bank_policy.rendered}"
  force_destroy          = "true"
  versioning_enabled     = "true"
  sse_algorithm          = "aws:kms"
  version_retention_days = "365"
  log_retention_days     = "365"                                 # 1 year
}

resource "aws_s3_bucket_object" "upload_interfaces_default_object" {
  key                    = "upload/readme.txt"
  bucket                 = "${var.namespace}-${var.environment}-${local.s3_interfaces_bucket}"
  content                = "Files uploaded into this directory structure will be processed by the system."
  server_side_encryption = "aws:kms"
  depends_on             = ["module.customer_s3_bucket"]
}

resource "aws_s3_bucket_object" "download_interfaces_default_object" {
  key                    = "download/readme.txt"
  bucket                 = "${var.namespace}-${var.environment}-${local.s3_interfaces_bucket}"
  content                = "Files created by the system are placed into this directory structure for download."
  server_side_encryption = "aws:kms"
  depends_on             = ["module.customer_s3_bucket"]
}

resource "aws_s3_bucket_object" "upload_origination_default_object" {
  key                    = "upload/readme.txt"
  bucket                 = "${var.namespace}-${var.environment}-${local.s3_origination_bucket}"
  content                = "Files uploaded into this directory structure will be processed by the system."
  server_side_encryption = "aws:kms"
  depends_on             = ["module.origination_s3_bucket"]
}

resource "aws_s3_bucket_object" "download_origination_default_object" {
  key                    = "download/readme.txt"
  bucket                 = "${var.namespace}-${var.environment}-${local.s3_origination_bucket}"
  content                = "Files created by the system are placed into this directory structure for download."
  server_side_encryption = "aws:kms"
  depends_on             = ["module.origination_s3_bucket"]
}

resource "aws_s3_bucket_object" "upload_insurance_default_object" {
  key                    = "upload/readme.txt"
  bucket                 = "${var.namespace}-${var.environment}-${local.s3_insurance_bucket}"
  content                = "Files uploaded into this directory structure will be processed by the system."
  server_side_encryption = "aws:kms"
  depends_on             = ["module.insurance_s3_bucket"]
}

resource "aws_s3_bucket_object" "download_insurance_default_object" {
  key                    = "download/readme.txt"
  bucket                 = "${var.namespace}-${var.environment}-${local.s3_insurance_bucket}"
  content                = "Files created by the system are placed into this directory structure for download."
  server_side_encryption = "aws:kms"
  depends_on             = ["module.insurance_s3_bucket"]
}

resource "aws_s3_bucket_object" "upload_bank_default_object" {
  key                    = "upload/readme.txt"
  bucket                 = "${var.namespace}-${var.environment}-${local.s3_bank_bucket}"
  content                = "Files uploaded into this directory structure will be processed by the system."
  server_side_encryption = "aws:kms"
  depends_on             = ["module.bank_s3_bucket"]
}

resource "aws_s3_bucket_object" "download_bank_default_object" {
  key                    = "download/readme.txt"
  bucket                 = "${var.namespace}-${var.environment}-${local.s3_bank_bucket}"
  content                = "Files created by the system are placed into this directory structure for download."
  server_side_encryption = "aws:kms"
  depends_on             = ["module.bank_s3_bucket"]
}
