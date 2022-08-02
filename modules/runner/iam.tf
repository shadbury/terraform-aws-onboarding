resource "aws_iam_role" "gitlab_runner" {
  name               = "gitlab_runner"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "ssmattach" {
  role       = aws_iam_role.gitlab_runner.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy" "assume_role" {
  name = "assume_role"
  role = aws_iam_role.gitlab_runner.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "sts:AssumeRole",
      "Resource": [
        "arn:aws:iam::*:role/gitlab_runner",
        "arn:aws:iam::*:role/*terraform-backend",
        "arn:aws:iam::*:role/${var.client}-role-gitlab-*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": "ec2:ModifyInstanceMetadataOptions",
      "Resource": "*"
    },
    {
      "Action": "ssm:GetParameters",
      "Resource": "arn:aws:ssm:ap-southeast-2:${data.aws_caller_identity.current}:parameter/gitlab-externalid",
      "Effect": "Allow"
    },
    {
      "Effect": "Allow",
      "Action": "ssm:GetParameter",
      "Resource": "arn:aws:ssm:*:*:parameter/gitlab/gitlab-runner-token"
    },
    {
      "Effect": "Allow",
      "Action": "kms:Decrypt",
      "Resource": "${aws_kms_key.kms.arn}"
    },
    {
      "Effect": "Allow",
      "Action": [
        "ssm:GetParameter", 
        "ssm:PutParameter"
      ],
      "Resource": "arn:aws:ssm:*:*:parameter/gitlab/config.toml"
    },
    {
      "Action": [
          "ecr:GetAuthorizationToken"
      ],
      "Resource": [
          "*"
      ],
      "Effect": "Allow"
    },
    {
      "Action": [
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage"
      ],
      "Resource": "arn:aws:ecr:${var.region}:*:repository/*",
      "Effect": "Allow"
    },
    {
      "Action": [
          "route53:ListHostedZonesByName",
          "route53:ChangeResourceRecordSets",
          "route53:GetHostedZone",
          "route53:ListResourceRecordSets"
      ],
      "Resource": "*",
      "Effect": "Allow"
    }
  ]
}
EOF
}
