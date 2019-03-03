#!/bin/bash

cat > /setenv.sh <<EOT
export CUSTOMER_NUMBER="${customer_number}"
export CUSTOMER_NAME="${customer_name}"
export S3_CONFIG_BUCKET="${s3_configuration_bucket}"
export S3_INTERFACES_BUCKET="${s3_interfaces_bucket}"
export S3_ORIGINATION_BUCKET="${s3_origination_bucket}"
export S3_INSURANCE_BUCKET="${s3_insurance_bucket}"
export S3_BANK_BUCKET="${s3_bank_bucket}"
export ROUTE53_ZONE_ID="${route53_zone_id}"
export ROUTE53_ZONE_NAME="${route53_zone_name}"
export SERVICE_HOSTNAME="${service_hostname}"
export S3FS_IAM_ROLE="${s3fs_iam_role}"
export LOG_GROUP_NAME="${log_group_name}"
export AWS_REGION="${aws_region}"
export IDS_PRODUCT="${ids_product}"
export IDS_PRODUCT_VERSION="${ids_product_version}"
export IDS_ENVIRONMENT="${ids_environment}"
export NFS_HOSTNAME="${nfs_hostname}"
EOT

chmod +x /setenv.sh
source /setenv.sh

yum install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm || ( wget https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/debian_amd64/amazon-ssm-agent.deb ; dpkg -i amazon-ssm-agent.deb)

/opt/automation/init_config/set-config.sh

