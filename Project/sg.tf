# #-------------------------------------------------------------
# #                  Security Group
# #-------------------------------------------------------------
# module "security_group" {
#   source = "../Modules/SG"

#   security_group_name = "Project-VPC-SG"
#   vpc_id              = module.vpc.vpc_id

#   ingresses = [
#     {
#       description = "Any port"
#       from_port   = 0
#       to_port     = 0
#       protocol    = "-1"
#       cidr_blocks = ["0.0.0.0/0"]
#     }
#   ]

#   egresses = [
#     {
#       description = "Any port"
#       from_port   = 0
#       to_port     = 0
#       protocol    = "-1"
#       cidr_blocks = ["0.0.0.0/0"]
#     }
#   ]

#   tags = {
#     Bu                  = "Take off"
#     App                 = "dspm"
#     Env                 = "dev/test/qa"
#     Owner               = "Dspm"
#     Data_classification = "private"
#   }
# }

#-------------------------------------------------------------
#                Custom EC2 Security Group
#-------------------------------------------------------------
module "security_group" {
  source = "../Modules/SG"

  security_group_name = "Custom-SG"
  vpc_id              = module.vpc.vpc_id

  ingresses = [
    {
      description = "ssh port"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      description = "Http port"
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      description = "Https port"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]

  egresses = [
    {
      description = "Any port"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]

  tags = local.tags
}

output "sg_id" {
  value = module.security_group.sg_id
}
# #-------------------------------------------------------------
# #                  EC2 Security Group
# #-------------------------------------------------------------
module "rds_security_group" {
  source = "../Modules/SG"

  security_group_name = "RDS-Aurora-Cluster-SG"
  vpc_id              = module.vpc.vpc_id

  ingresses = [
    {
      description = "ssh port"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      description = "Http port"
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      description = "Https port"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]

  egresses = [
    {
      description = "Any port"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]

  tags = local.tags
}