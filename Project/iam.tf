#----------------------------------------------------------------------------------------
#                             IAM - USER
#----------------------------------------------------------------------------------------

module "iam-user" {
  source = "../Modules/IAM/User"

  iam_user_name = "admin-user"
  user_path     = "/"
  policy_arn    = "arn:aws:iam::aws:policy/AdministratorAccess"
  tags          = local.tags
}

#----------------------------------------------------------------------------------------
#                             IAM - ROLE
#----------------------------------------------------------------------------------------

module "iam-role" {
  source = "../Modules/IAM/Role"

  role_name = "admin-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
  tags       = local.tags
}

#----------------------------------------------------------------------------------------
#                             IAM - POLICY
#----------------------------------------------------------------------------------------

module "iam-policy" {
  source = "../Modules/IAM/Policy"

  policy_name = "admin-policy"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "*",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
  tags = local.tags
}