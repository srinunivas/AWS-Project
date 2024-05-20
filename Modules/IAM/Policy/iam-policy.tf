resource "aws_iam_policy" "policy" {
  name        = var.policy_name #"test_policy"
  path        = var.path        #"/"
  description = var.description #"The test policy"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = var.policy
  tags   = var.tags
}