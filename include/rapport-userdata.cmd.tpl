<script>
echo set "CUSTOMER_NUMBER=${customer_number}" > c:\setenv.cmd
echo set "CUSTOMER_NAME=${customer_name}" >> c:\setenv.cmd
echo set "S3_CONFIG_BUCKET=${s3_configuration_bucket}" >> c:\setenv.cmd
echo set "S3_INTERFACES_BUCKET=${s3_interfaces_bucket}" >> c:\setenv.cmd
echo set "S3_ORIGINATION_BUCKET=${s3_origination_bucket}" >> c:\setenv.cmd
echo set "S3_INSURANCE_BUCKET=${s3_insurance_bucket}" >> c:\setenv.cmd
echo set "S3_BANK_BUCKET=${s3_bank_bucket}" >> c:\setenv.cmd
echo set "ROUTE53_ZONE_ID=${route53_zone_id}" >> c:\setenv.cmd
echo set "ROUTE53_ZONE_NAME=${route53_zone_name}" >> c:\setenv.cmd
echo set "SERVICE_HOSTNAME=${service_hostname}" >> c:\setenv.cmd
echo set "S3FS_IAM_ROLE=${s3fs_iam_role}" >> c:\setenv.cmd
echo set "LOG_GROUP_NAME=${log_group_name}" >> c:\setenv.cmd
echo set "AWS_REGION=${aws_region}" >> c:\setenv.cmd
echo set "IDS_PRODUCT=${ids_product}" >> c:\setenv.cmd
echo set "IDS_PRODUCT_VERSION=${ids_product_version}" >> c:\setenv.cmd
echo set "IDS_ENVIRONMENT=${ids_environment}" >> c:\setenv.cmd
echo set "RAPPORT_HOSTNAME=${rapport_hostname}" >> c:\setenv.cmd

echo "Calling set-config.cmd ..."
call c:\setenv.cmd
C:\automation\init_config\set-config.cmd
</script>
