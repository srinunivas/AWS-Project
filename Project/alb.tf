#-------------------------------------------------------------
#                 Application Load Balancer - public - EC2's
#-------------------------------------------------------------

module "alb_ec2_public" {
  source = "../Modules/ELB/ALB"

  depends_on = [module.public_ec2_linux1, module.public_ec2_linux1]

  alb_name        = "a1"
  vpc_id          = module.vpc.vpc_id
  subnet_ids      = [module.vpc.public_subnet_id_1, module.vpc.public_subnet_id_2]
  security_groups = [module.security_group.sg_id]

  target_groups_listener = {
    target-group2 = {
      port                = 80
      targetgroup_port    = 80
      protocol            = "HTTP"
      target_type         = "instance"
      healthy_threshold   = 2
      unhealthy_threshold = 2
      timeout             = 3
      interval            = 30
      listeners = {
        port = 80
      }
      targets = [module.public_ec2_linux1.instance_id, module.public_ec2_linux2.instance_id]
    }
  }

  tags = local.tags
  org_name = "Safemarch"
  project_name = "demo"
  env = "prod"
  region = "us-east-2"
}

#-------------------------------------------------------------
#                 Application Load Balancer - Private - EC2's
#-------------------------------------------------------------

module "alb_ec2_private" {
  source = "../Modules/ELB/ALB"

  depends_on = [module.private_ec2_linux1, module.private_ec2_linux2]

  alb_name        = "a2"
  vpc_id          = module.vpc.vpc_id
  subnet_ids      = [module.vpc.private_subnet_id_1, module.vpc.private_subnet_id_2]
  security_groups = [module.vpc.default_security_group_id]

  target_groups_listener = {
    target-group2 = {
      port                = 80
      targetgroup_port    = 80
      protocol            = "HTTP"
      target_type         = "instance"
      healthy_threshold   = 2
      unhealthy_threshold = 2
      timeout             = 3
      interval            = 30
      listeners = {
        port = 80
      }
      targets = [module.private_ec2_linux1.instance_id, module.private_ec2_linux2.instance_id]
    }
  }

  tags = local.tags
  org_name = "safemarch"
  project_name = "demo"
  env = "prod"
  region = "us-east-2"
}


