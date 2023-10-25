resource "aws_iam_group" "developers" {
  // terraform import aws_iam_group.developers developers
  name = "developers"
}

resource "aws_iam_policy" "developers_bucket_access" {
  name        = "S3BucketDevelopersAccess"
  description = "IAM policy for reading different buckets for developers"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "S3BucketDevelopersAccess"
        Effect = "Allow"
        Action = [
          "s3:PutObject",
          "s3:PutObjectAcl",
          "s3:GetObject",
          "s3:GetObjectAcl",
          "s3:DeleteObject"
        ]
        Resource = [
          "arn:aws:s3:::xxxxx/*",
          "arn:aws:s3:::xxxxx/*",
          "arn:aws:s3:::xxxx/*",
          "arn:aws:s3:::xxxxx/*",
          "arn:aws:s3:::xxxxxxxxxxx/*"
        ]
      }
    ]
  })
}

resource "aws_iam_policy" "developers_ecs_access" {
  name        = "ECSDeveloperAccess"
  description = "IAM policy for accessing ECS"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "ECSDeveloperAccess"
        Effect = "Allow"
        Action = [
          "application-autoscaling:DescribeScalableTargets",
          "application-autoscaling:DescribeScalingActivities",
          "application-autoscaling:DescribeScalingPolicies",
          "autoscaling:Describe*",
          "cloudwatch:Describe*",
          "cloudwatch:GetMetricStatistics",
          "cloudwatch:ListMetrics",
          "ec2:Describe*",
          "ecr:DescribeImages",
          "ecr:DescribeRegistry",
          "ecr:DescribeRepositories",
          "ecr:ListImages",
          "ecr:ListTagsForResource",
          "ecs:DescribeCapacityProviders",
          "ecs:DescribeClusters",
          "ecs:DescribeContainerInstances",
          "ecs:DescribeServices",
          "ecs:DescribeTaskDefinition",
          "ecs:DescribeTasks",
          "ecs:DescribeTaskSets",
          "ecs:ListAttributes",
          "ecs:ListClusters",
          "ecs:ListContainerInstances",
          "ecs:ListServices",
          "ecs:ListServicesByNamespace",
          "ecs:ListTagsForResource",
          "ecs:ListTasks",
          "ecs:ListTaskDefinitionFamilies",
          "ecs:ListTaskDefinitions",
          "elasticloadbalancing:Describe",
          "events:DescribeRule",
          "events:ListRuleNamesByTarget",
          "events:ListTargetsByRule",
        ]
        Resource = [
          "*"
        ]
        Condition = {
          Bool = {
            "aws:MultiFactorAuthPresent" : "true"
          }
        }
      }
    ]
  })
}




resource "aws_iam_group_policy_attachment" "developers_cloudfront_full_access" {
  group      = aws_iam_group.developers.name
  policy_arn = "arn:aws:iam::aws:policy/CloudFrontFullAccess"
}

resource "aws_iam_group_policy_attachment" "developers_cloudwatch_read_only_access" {
  group      = aws_iam_group.developers.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchLogsReadOnlyAccess"
}

resource "aws_iam_group_policy_attachment" "developers_rds_read_only_access" {
  group      = aws_iam_group.developers.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonRDSReadOnlyAccess"
}
resource "aws_iam_group_policy_attachment" "developers_s3_read_only_access" {
  group      = aws_iam_group.developers.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}

resource "aws_iam_group_policy_attachment" "developers_lambda_full_access" {
  group      = aws_iam_group.developers.name
  policy_arn = "arn:aws:iam::aws:policy/AWSLambda_FullAccess"
}

resource "aws_iam_group_policy_attachment" "developer_access_production" {
  group      = aws_iam_group.developers.name
  policy_arn = aws_iam_policy.developer_access_production.arn
}

resource "aws_iam_group_policy_attachment" "ssm_access" {
  group      = aws_iam_group.developers.name
  policy_arn = aws_iam_policy.ssm_access.arn
}

resource "aws_iam_group_policy_attachment" "developers_ecs_access" {
  group      = aws_iam_group.developers.name
  policy_arn = aws_iam_policy.developers_ecs_access.arn
}

resource "aws_iam_group_policy_attachment" "developers_bucket_access" {
  group      = aws_iam_group.developers.name
  policy_arn = aws_iam_policy.developers_bucket_access.arn
}
