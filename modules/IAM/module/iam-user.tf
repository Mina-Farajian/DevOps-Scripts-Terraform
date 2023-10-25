
resource "aws_iam_user" "this" {
  name = var.name
  tags = var.tags
}

variable "name" {
  type = string

}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "groups" {
  type    = list(string)
  default = []
}

variable "policy_arns" {
  type    = list(string)
  default = []
}

resource "aws_iam_user_group_membership" "this" {

  user = aws_iam_user.this.name

  groups = var.groups
}

resource "aws_iam_user_policy_attachment" "this" {
  count      = length(var.policy_arns)
  user       = aws_iam_user.this.name
  policy_arn = element(var.policy_arns, count.index)
}

output "name" {
  value = aws_iam_user.this.name
}
