# InfoLease EC2 role
resource "aws_iam_role" "infolease_instance_role" {
  name_prefix        = "${var.customer_name}_IL_"
  description        = "InfoLease EC2 role for ${var.customer_name}"
  assume_role_policy = "${file("${path.module}/include/assume-role-policy.json")}"
}

resource "aws_iam_instance_profile" "infolease_instance_profile" {
  name_prefix = "IL_${var.customer_name}_"
  role        = "${aws_iam_role.infolease_instance_role.name}"
}

# Reporting EC2 role
resource "aws_iam_role" "reporting_instance_role" {
  name_prefix        = "${var.customer_name}_Reporting_"
  description        = "Reporting EC2 role for ${var.customer_name}"
  assume_role_policy = "${file("${path.module}/include/assume-role-policy.json")}"
}

resource "aws_iam_instance_profile" "reporting_instance_profile" {
  name_prefix = "IL_${var.customer_name}_"
  role        = "${aws_iam_role.reporting_instance_role.name}"
}

# Rapport EC2 role
resource "aws_iam_role" "rapport_instance_role" {
  name_prefix        = "${var.customer_name}_Rapport_"
  description        = "Rapport EC2 role for ${var.customer_name}"
  assume_role_policy = "${file("${path.module}/include/assume-role-policy.json")}"
}

resource "aws_iam_instance_profile" "rapport_instance_profile" {
  name_prefix = "Rapport_${var.customer_name}_"
  role        = "${aws_iam_role.rapport_instance_role.name}"
}

# Policy: S3 from EC2
data "aws_iam_policy_document" "to_s3_bucket" {
  statement {
    sid     = "ListBuckets"
    effect  = "Allow"
    actions = ["s3:ListBucket"]

    resources = [
      "arn:aws:s3:::${var.s3_configuration_bucket}",
    ]
  }

  statement {
    sid     = "ListConfigurationObjects"
    effect  = "Allow"
    actions = ["s3:List*"]

    resources = [
      "arn:aws:s3:::${var.s3_configuration_bucket}",
      "arn:aws:s3:::${var.s3_configuration_bucket}/*",
    ]
  }

  statement {
    effect  = "Allow"
    actions = ["s3:Get*"]

    resources = [
      "arn:aws:s3:::${var.s3_configuration_bucket}/${var.customer_name}",
      "arn:aws:s3:::${var.s3_configuration_bucket}/${var.customer_name}/*",
      "arn:aws:s3:::${var.s3_configuration_bucket}/scripts",
      "arn:aws:s3:::${var.s3_configuration_bucket}/scripts/*",
    ]
  }
}

# Policy: S3 files from EC2
data "aws_iam_policy_document" "to_s3_files_bucket" {
  statement {
    sid     = "ListBuckets"
    effect  = "Allow"
    actions = ["s3:ListBucket"]

    resources = [
      "arn:aws:s3:::${local.s3_interfaces_bucket}",
      "arn:aws:s3:::${local.s3_origination_bucket}",
      "arn:aws:s3:::${local.s3_insurance_bucket}",
      "arn:aws:s3:::${local.s3_bank_bucket}",
    ]
  }

  statement {
    sid     = "CRUDObjects"
    effect  = "Allow"
    actions = ["s3:*"]

    resources = [
      "arn:aws:s3:::${local.s3_interfaces_bucket}",
      "arn:aws:s3:::${local.s3_interfaces_bucket}/*",
      "arn:aws:s3:::${local.s3_origination_bucket}",
      "arn:aws:s3:::${local.s3_origination_bucket}/*",
      "arn:aws:s3:::${local.s3_insurance_bucket}",
      "arn:aws:s3:::${local.s3_insurance_bucket}/*",
      "arn:aws:s3:::${local.s3_bank_bucket}",
      "arn:aws:s3:::${local.s3_bank_bucket}/*",
    ]
  }
}

# Policy: IAM SendCommand
data "aws_iam_policy_document" "ssm_sendcommand" {
  statement {
    effect    = "Allow"
    actions   = ["ssm:SendCommand"]
    resources = ["*"]

    condition {
      test     = "StringLike"
      variable = "ssm:resourceTag/Customer"
      values   = ["${var.customer_name}"]
    }
  }

  statement {
    effect  = "Allow"
    actions = ["ssm:SendCommand"]

    resources = [
      "arn:aws:ssm:${data.aws_region.current.name}::document/AWS-*",
    ]
  }

  statement {
    effect = "Allow"

    actions = ["ssm:UpdateInstanceInformation",
      "ssm:ListCommands",
      "ssm:ListCommandInvocations",
      "ssm:GetDocument",
    ]

    resources = ["*"]
  }
}

resource "aws_iam_policy" "ssm_sendcommand" {
  name_prefix = "cust_${var.customer_name}_SSM_"
  description = "SSM access from EC2 for ${var.customer_name}"
  policy      = "${data.aws_iam_policy_document.ssm_sendcommand.json}"
}

resource "aws_iam_role_policy_attachment" "il_ssmsendcommand" {
  role       = "${aws_iam_role.infolease_instance_role.name}"
  policy_arn = "${aws_iam_policy.ssm_sendcommand.arn}"
}

resource "aws_iam_role_policy_attachment" "reporting_ssmsendcommand" {
  role       = "${aws_iam_role.reporting_instance_role.name}"
  policy_arn = "${aws_iam_policy.ssm_sendcommand.arn}"
}

resource "aws_iam_role_policy_attachment" "rapport_ssmsendcommand" {
  role       = "${aws_iam_role.rapport_instance_role.name}"
  policy_arn = "${aws_iam_policy.ssm_sendcommand.arn}"
}

# Access to S3 bucket
resource "aws_iam_policy" "to_s3_bucket" {
  name_prefix = "cust_${var.customer_name}_to_S3_configs_"
  description = "S3 access from EC2 for ${var.customer_name} configurations"
  policy      = "${data.aws_iam_policy_document.to_s3_bucket.json}"
}

resource "aws_iam_policy" "to_s3_files_bucket" {
  name_prefix = "cust_${var.customer_name}_to_S3_interfaces_"
  description = "S3 access from EC2 for ${var.customer_name} interface files"
  policy      = "${data.aws_iam_policy_document.to_s3_files_bucket.json}"
}

resource "aws_iam_role_policy_attachment" "il_to_s3_bucket" {
  role       = "${aws_iam_role.infolease_instance_role.name}"
  policy_arn = "${aws_iam_policy.to_s3_bucket.arn}"
}

resource "aws_iam_role_policy_attachment" "rpt_to_s3_bucket" {
  role       = "${aws_iam_role.reporting_instance_role.name}"
  policy_arn = "${aws_iam_policy.to_s3_bucket.arn}"
}

resource "aws_iam_role_policy_attachment" "rapport_to_s3_bucket" {
  role       = "${aws_iam_role.rapport_instance_role.name}"
  policy_arn = "${aws_iam_policy.to_s3_bucket.arn}"
}

resource "aws_iam_role_policy_attachment" "il_to_s3_files_bucket" {
  role       = "${aws_iam_role.infolease_instance_role.name}"
  policy_arn = "${aws_iam_policy.to_s3_files_bucket.arn}"
}

resource "aws_iam_role_policy_attachment" "rpt_to_s3_files_bucket" {
  role       = "${aws_iam_role.reporting_instance_role.name}"
  policy_arn = "${aws_iam_policy.to_s3_files_bucket.arn}"
}

# Policy: Route 53 from EC2
data "aws_iam_policy_document" "route53" {
  statement {
    effect = "Allow"

    actions = ["route53:GetHostedZone",
      "route53:ChangeResourceRecordSets",
      "route53:ListResourceRecordSets",
    ]

    resources = ["arn:aws:route53:::hostedzone/${aws_route53_zone.main.id}"]
  }
}

resource "aws_iam_policy" "route53" {
  name_prefix = "cust_${var.customer_name}_Route53_"
  description = "Route53 access from EC2 for ${var.customer_name}"
  policy      = "${data.aws_iam_policy_document.route53.json}"
}

resource "aws_iam_role_policy_attachment" "il_route53" {
  role       = "${aws_iam_role.infolease_instance_role.name}"
  policy_arn = "${aws_iam_policy.route53.arn}"
}

resource "aws_iam_role_policy_attachment" "reporting_route53" {
  role       = "${aws_iam_role.reporting_instance_role.name}"
  policy_arn = "${aws_iam_policy.route53.arn}"
}

resource "aws_iam_role_policy_attachment" "rapport_route53" {
  role       = "${aws_iam_role.rapport_instance_role.name}"
  policy_arn = "${aws_iam_policy.route53.arn}"
}

# Cloudwatch Logs
data "aws_iam_policy_document" "cloudwatch_logs" {
  statement {
    effect = "Allow"

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:DescribeLogStreams",
    ]

    resources = [
      "${aws_cloudwatch_log_group.infolease.arn}",
      "${aws_cloudwatch_log_group.reporting.arn}",
    ]
  }
}

resource "aws_iam_policy" "cloudwatch_logs" {
  name_prefix = "cust_${var.customer_name}_Logs_"
  description = "Cloudwatch Logs access from EC2 for ${var.customer_name}"
  policy      = "${data.aws_iam_policy_document.cloudwatch_logs.json}"
}

resource "aws_iam_role_policy_attachment" "il_cloudwatch_logs" {
  role       = "${aws_iam_role.infolease_instance_role.name}"
  policy_arn = "${aws_iam_policy.cloudwatch_logs.arn}"
}

resource "aws_iam_role_policy_attachment" "reporting_cloudwatch_logs" {
  role       = "${aws_iam_role.reporting_instance_role.name}"
  policy_arn = "${aws_iam_policy.cloudwatch_logs.arn}"
}

resource "aws_iam_role_policy_attachment" "rapport_cloudwatch_logs" {
  role       = "${aws_iam_role.rapport_instance_role.name}"
  policy_arn = "${aws_iam_policy.cloudwatch_logs.arn}"
}

# SSM role for InfoLease/Reporting/Rapport
resource "aws_iam_role_policy_attachment" "il_ssm" {
  role       = "${aws_iam_role.infolease_instance_role.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM"
}

resource "aws_iam_role_policy_attachment" "rapport_ssm" {
  role       = "${aws_iam_role.rapport_instance_role.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM"
}

resource "aws_iam_role_policy_attachment" "reporting_ssm" {
  role       = "${aws_iam_role.reporting_instance_role.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM"
}

# access to credstash
resource "aws_iam_role_policy_attachment" "il_secrets" {
  role       = "${aws_iam_role.infolease_instance_role.name}"
  policy_arn = "${var.credstash_reader_arn}"
}

resource "aws_iam_role_policy_attachment" "rapport_secrets" {
  role       = "${aws_iam_role.rapport_instance_role.name}"
  policy_arn = "${var.credstash_reader_arn}"
}

resource "aws_iam_role_policy_attachment" "reporting_secrets" {
  role       = "${aws_iam_role.reporting_instance_role.name}"
  policy_arn = "${var.credstash_reader_arn}"
}

# credstash kms role policy
resource "aws_iam_policy" "credstash_kms" {
  name_prefix = "cust_${var.customer_name}_kms_"
  description = "CredStash KMS access from EC2 for ${var.customer_name}"
  policy      = "${data.aws_iam_policy_document.credstash_kms.json}"
}

data "aws_iam_policy_document" "credstash_kms" {
  statement {
    effect = "Allow"

    actions = [
      "kms:Decrypt",
    ]

    resources = [
      "${var.credstash_kms_arn}",
    ]
  }
}

resource "aws_iam_role_policy_attachment" "infolease_credstash" {
  role       = "${aws_iam_role.infolease_instance_role.name}"
  policy_arn = "${aws_iam_policy.credstash_kms.arn}"
}

resource "aws_iam_role_policy_attachment" "rapport_credstash" {
  role       = "${aws_iam_role.rapport_instance_role.name}"
  policy_arn = "${aws_iam_policy.credstash_kms.arn}"
}

resource "aws_iam_role_policy_attachment" "reporting_credstash" {
  role       = "${aws_iam_role.reporting_instance_role.name}"
  policy_arn = "${aws_iam_policy.credstash_kms.arn}"
}
