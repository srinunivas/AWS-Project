resource "aws_iam_user" "user" {
  name = "${var.org_name}-${var.project_name}-${var.env}-${var.region}-${var.iam_user_name}"
  path = var.user_path

  tags = var.tags
}

resource "aws_iam_user_policy_attachment" "example_attachment" {
  user       = aws_iam_user.user.name
  policy_arn = var.policy_arn
}

resource "aws_iam_access_key" "example_access_key" {
  user = aws_iam_user.user.name
}
