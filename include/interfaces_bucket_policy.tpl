{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "AWS": [
		  "arn:aws:iam::${account_id}:root"
		  ]
            },
            "Action": [
                "s3:Get*",
                "s3:List*"
            ],
            "Resource": [
                "arn:aws:s3:::${namespace}-${environment_name}-${s3_interfaces_bucket}",
                "arn:aws:s3:::${namespace}-${environment_name}-${s3_interfaces_bucket}/*"
            ]
        }
    ]
}
