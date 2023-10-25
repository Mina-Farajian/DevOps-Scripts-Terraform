locals {
  developer_role_name = "company-developers-Role"
}

variable "master_account_id" {
  description = "The ID of the master account"
  default     = "Account ID"
}


resource "aws_iam_policy" "developers_action" {
  name = "developers-action"

  policy = jsonencode(
    {
      Version = "2012-10-17"
      Statement = [
        {
          Sid    = "VisualEditor0"
          Effect = "Allow"
          Action = [
            "iam:GetPolicyVersion",
            "iam:GetAccountPasswordPolicy",
            "iam:ListRoleTags",
            "iam:ListServerCertificates",
            "iam:GenerateServiceLastAccessedDetails",
            "ecs:DescribeTaskSets",
            "iam:ListServiceSpecificCredentials",
            "iam:ListSigningCertificates",
            "iam:ListVirtualMFADevices",
            "ecs:DescribeTaskDefinition",
            "ecs:DescribeCapacityProviders",
            "iam:ListSSHPublicKeys",
            "iam:SimulateCustomPolicy",
            "iam:SimulatePrincipalPolicy",
            "iam:GetAccountEmailAddress",
            "iam:ListAttachedRolePolicies",
            "iam:ListOpenIDConnectProviderTags",
            "iam:ListSAMLProviderTags",
            "iam:ListRolePolicies",
            "iam:GetAccountAuthorizationDetails",
            "iam:GetCredentialReport",
            "ecs:ListTaskDefinitions",
            "iam:ListPolicies",
            "iam:GetServerCertificate",
            "iam:GetRole",
            "iam:ListSAMLProviders",
            "iam:GetPolicy",
            "iam:GetAccessKeyLastUsed",
            "iam:ListEntitiesForPolicy",
            "ecs:DescribeClusters",
            "iam:GetUserPolicy",
            "iam:ListGroupsForUser",
            "iam:GetAccountName",
            "ecs:ListContainerInstances",
            "iam:GetGroupPolicy",
            "iam:GetOpenIDConnectProvider",
            "iam:ListSTSRegionalEndpointsStatus",
            "iam:GetRolePolicy",
            "iam:GetAccountSummary",
            "iam:GenerateCredentialReport",
            "ecs:ListAttributes",
            "iam:GetServiceLastAccessedDetailsWithEntities",
            "iam:ListPoliciesGrantingServiceAccess",
            "iam:ListInstanceProfileTags",
            "iam:ListMFADevices",
            "iam:GetServiceLastAccessedDetails",
            "iam:GetGroup",
            "iam:GetContextKeysForPrincipalPolicy",
            "iam:GetOrganizationsAccessReport",
            "ecs:ListServices",
            "iam:GetServiceLinkedRoleDeletionStatus",
            "iam:ListInstanceProfilesForRole",
            "ecs:ListTasks",
            "iam:GenerateOrganizationsAccessReport",
            "iam:GetCloudFrontPublicKey",
            "iam:ListAttachedUserPolicies",
            "ecs:DescribeServices",
            "iam:ListAttachedGroupPolicies",
            "iam:ListPolicyTags",
            "ecs:DescribeContainerInstances",
            "ecs:DescribeTasks",
            "iam:GetSAMLProvider",
            "ecs:ListClusters",
            "iam:ListAccessKeys",
            "ecs:ListServicesByNamespace",
            "iam:GetInstanceProfile",
            "iam:ListGroupPolicies",
            "iam:ListCloudFrontPublicKeys",
            "iam:GetSSHPublicKey",
            "iam:ListRoles",
            "iam:ListUserPolicies",
            "iam:ListInstanceProfiles",
            "iam:GetContextKeysForCustomPolicy",
            "ecs:ListAccountSettings",
            "ecs:ListTagsForResource",
            "iam:ListPolicyVersions",
            "iam:ListOpenIDConnectProviders",
            "ecs:ListTaskDefinitionFamilies",
            "iam:ListServerCertificateTags",
            "iam:ListAccountAliases",
            "iam:ListUsers",
            "iam:GetUser",
            "iam:ListGroups",
            "iam:ListMFADeviceTags",
            "iam:GetLoginProfile",
            "iam:ListUserTags"
          ]
          Resource = "*"
        }
      ]
    }
  )
}

data "aws_iam_policy_document" "developer_assume_role" {
  statement {
    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${var.master_account_id}:root"]
    }

    effect = "Allow"
  }
}



# https://www.terraform.io/docs/providers/aws/r/iam_role.html
resource "aws_iam_role" "developer_role" {
  name               = local.developer_role_name
  assume_role_policy = data.aws_iam_policy_document.developer_assume_role.json
  description        = "The role to grant permissions to this account to delegated IAM users in the master account"
}

# https://www.terraform.io/docs/providers/aws/r/iam_role_policy_attachment.html
# By default it attaches `AdministratorAccess` managed policy to grant full access to AWS services and resources in the current account
resource "aws_iam_role_policy_attachment" "cloud_front_read_only_access" {
  role       = aws_iam_role.developer_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudFrontReadOnlyAccess"
}

resource "aws_iam_role_policy_attachment" "cloud_watch_read_only_access" {
  role       = aws_iam_role.developer_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchReadOnlyAccess"
}
resource "aws_iam_role_policy_attachment" "ec2_read_only_access" {
  role       = aws_iam_role.developer_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess"
}
resource "aws_iam_role_policy_attachment" "rds_read_only_access" {
  role       = aws_iam_role.developer_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonRDSReadOnlyAccess"
}
resource "aws_iam_role_policy_attachment" "s3_read_only_access" {
  role       = aws_iam_role.developer_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}

resource "aws_iam_role_policy_attachment" "developers_action" {
  role       = aws_iam_role.developer_role.name
  policy_arn = aws_iam_policy.developers_action.arn
}
