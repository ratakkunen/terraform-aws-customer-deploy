variable "ami_owners" {
  type    = "list"
  default = ["self", "450625201782", "777875878886", "491692662146"]
}

variable "lb_security_group_id" {
  type = "string"
}

variable "vpc_id" {
  type = "string"
}

variable "alb_http_listener_arn" {
  type    = "string"
  default = ""
}

variable "alb_https_listener_arn" {
  type    = "string"
  default = ""
}

variable "infolease_hostname" {
  type = "string"
}

variable "reporting_instance_type" {
  type    = "string"
  default = "m5.xlarge"
}

variable "infolease_instance_type" {
  type    = "string"
  default = "m5.xlarge"
}

variable "rapport_instance_type" {
  type    = "string"
  default = "m5.xlarge"
}

variable "infolease_version" {
  type = "string"
}

variable "reporting_pentaho_version" {
  type    = "string"
  default = "false"
}

variable "reporting_idsreporting_version" {
  type    = "string"
  default = "false"
}

variable "reporting_infoleasereporting_version" {
  type    = "string"
  default = "false"
}

variable "reporting_rapportreporting_version" {
  type    = "string"
  default = "false"
}

variable "app_channel" {
  type = "string"

  default = "stable"
}

variable "customer_name" {
  type = "string"
}

variable "customer_number" {
  type = "string"
}

variable "private_subnets" {
  type = "list"
}

variable "key_name" {
  type = "string"
}

variable "min_infolease_servers" {
  default = 1
}

variable "max_infolease_servers" {
  default = 2
}

variable "desired_infolease_servers" {
  default = 1
}

variable "service_dns_zone_name" {
  type = "string"
}

variable "s3_configuration_bucket" {
  type = "string"
}

variable "s3_files_bucket" {
  type = "string"
}

variable "additional_security_groups" {
  type    = "list"
  default = []
}

variable "min_reporting_servers" {
  default = 1
}

variable "max_reporting_servers" {
  default = 2
}

variable "desired_reporting_servers" {
  default = 1
}

variable "min_rapport_servers" {
  default = 1
}

variable "max_rapport_servers" {
  default = 2
}

variable "desired_rapport_servers" {
  default = 1
}

variable "log_retention_days_infolease" {
  type    = "string"
  default = "365"
}

variable "log_retention_days_reporting" {
  type    = "string"
  default = "365"
}

variable "rapport_hostname" {
  type = "string"
}

variable "rapport_version" {
  type = "string"
}

variable "environment" {
  type        = "string"
  default     = "dev"
  description = "The current environment or `stage` that is being deployed."
}

variable "asg_suspended_processes" {
  type    = "list"
  default = []
}

variable "internal_ips" {
  type    = "list"
  default = ["10.0.0.0/8", "192.168.0.0/16", "172.16.0.0/12"]
}

data "aws_region" "current" {
}

variable "credstash_reader_arn" {
  type = "string"
}

variable "credstash_kms_arn" {
  type = "string"
}

variable "namespace" {
  type        = "string"
  default     = "idsgrp"
  description = "The prefix namespace for all things cloud (e.g. idsgrp or ids)"
}
