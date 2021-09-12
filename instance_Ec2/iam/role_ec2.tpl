{
	"Version": "2012-10-17",
	"Statement": [{
			"Sid": "Stmt1492028354000",
			"Effect": "Allow",
			"Action": [
				"sts:AssumeRole"
			],
			"Resource": [
				"arn:aws:iam::640247541945:role/AmazonEC2RoleforSSM"
			]
		},
		{
			"Sid": "GetTags",
			"Effect": "Allow",
			"Action": [
				"ec2:Describe*",
				"ec2:TerminateInstances"
			],
			"Resource": "*"
		},
		{		
			"Sid": "AmazonEC2CreateSnapshots",
			"Effect": "Allow",
			"Action": [
					"ec2:CreateSnapshot",
					"ec2:DeleteSnapshot",
					"ec2:DescribeSnapshots",
					"ec2:DescribeInstances",
					"ec2:CreateTags"
				],
				"Resource": "*"
		},
		{
			"Sid": "CollecteOfMetriques",
			"Effect": "Allow",
			"Action": [
				"cloudwatch:PutMetricData",
				"cloudwatch:GetMetricStatistics",
				"cloudwatch:ListMetrics"
			],
			"Resource": "*"
		},
		{
			"Sid": "AllowBucketListing",
			"Effect": "Allow",
			"Action": [
				"s3:ListBucket", "s3:GetObject", "s3:PutObject"
			],
			"Resource": [
				"arn:aws:s3:::bucket-ansible-tools",
				"arn:aws:s3:::bucket-ansible-tools/*"
			]
		},
		{
			"Sid": "Logging",
			"Effect": "Allow",
			"Action": [
				"logs:DescribeLogStreams",
				"logs:CreateLogStream",
				"logs:CreateLogGroup",
				"logs:PutLogEvents"
			],
			"Resource": "arn:aws:logs:*:*:*"
		}
	]
}