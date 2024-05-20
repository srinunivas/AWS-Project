resource "aws_iam_role" "test_role" {
  name = var.role_name
  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = var.assume_role_policy
  tags               = var.tags
}

resource "aws_iam_role_policy_attachment" "admin_attachment" {
  role       = aws_iam_role.test_role.name
  policy_arn = var.policy_arn # Example policy ARN, change as needed
}