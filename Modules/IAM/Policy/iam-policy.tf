resource "aws_iam_policy" "policy" {
  name        = "${var.org_name}-${var.project_name}-${var.env}-${var.region}-${var.policy_name}"
  path        = var.path
  description = var.description
  policy      = var.policy
  tags        = var.tags
}