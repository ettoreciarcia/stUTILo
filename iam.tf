resource "aws_iam_policy" "eks_nodegroup_policy" {
  name        = "${var.cluster_name}-nodegroup-policy"
  description = "Policy for managing nodegroups in the ${var.cluster_name} EKS cluster"

  policy = <<EOT
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "autoscaling:UpdateAutoScalingGroup",
                "autoscaling:DescribeAutoScalingGroups"
            ],
            "Resource": "*"
        },
        {
            "Sid": "AllowCloudWatchActions",
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ],
            "Resource": "arn:aws:logs:${var.region}:${data.aws_caller_identity.current.account_id}:log-group:*"
        }
    ]
}
EOT
}




resource "aws_iam_role" "scale_role_lambda" {
  name = "${var.cluster_name}-scale-role-lambda"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "sts:AssumeRole"
            ],
            "Principal": {
                "Service": [
                    "lambda.amazonaws.com"
                ]
            }
        }
    ]
}
EOF

}

resource "aws_iam_role_policy_attachment" "aws_iam_role_policy_attachment" {
  role       = aws_iam_role.scale_role_lambda.name
  policy_arn = aws_iam_policy.eks_nodegroup_policy.arn
}
