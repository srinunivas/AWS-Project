resource "aws_iam_role" "test_role" {
  name               = "${var.org_name}-${var.project_name}-${var.env}-${var.region}-${var.role_name}"
  assume_role_policy = var.assume_role_policy
  tags               = var.tags
}

resource "aws_iam_role_policy_attachment" "admin_attachment" {
  role       = aws_iam_role.test_role.name
  policy_arn = var.policy_arn
}