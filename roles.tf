resource "aws_iam_role_policy" "discovery_policy" {
  name = "${var.ES_CLUSTER_NAME}-policy-discovery"
  role = aws_iam_role.discovery_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ec2:DescribeInstances",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

resource "aws_iam_role_policy" "snapshot_policy" {
  name = "${var.ES_CLUSTER_NAME}-policy-snapshot"
  role = aws_iam_role.discovery_role.id

  policy = jsonencode({
   "Version": "2012-10-17",
   "Statement": [{
       "Action": [
         "s3:ListBucket"
       ],
       "Effect": "Allow",
       "Resource": [
         "arn:aws:s3:::${var.ES_CLUSTER_NAME}-snapshot-bucket"
       ]
     },
     {
       "Action": [
         "s3:GetObject",
         "s3:PutObject",
         "s3:DeleteObject"
       ],
       "Effect": "Allow",
       "Resource": [
         "arn:aws:s3:::${var.ES_CLUSTER_NAME}-snapshot-bucket/*"
       ]
     }
   ]
 })
}

resource "aws_iam_role" "discovery_role" {
  name = "${var.ES_CLUSTER_NAME}-role-discovery"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_instance_profile" "discovery_profile" {
  name  = "${var.ES_CLUSTER_NAME}-profile-discovery"
  role = aws_iam_role.discovery_role.name
}


