#-------------------------------------------------------------
#                   ASG - Network Load Balancer
#-------------------------------------------------------------
module "network_load_balancer" {
  source = "../Modules/ELB/NLB"

  network_load_balancer = ({
    name               = "n3"
    subnet_ids         = [module.vpc.public_subnet_id_1]
    access_logs_bucket = module.s3_nlb_access_logs.s3_bucket_id
  })
  security_groups = [module.security_group.sg_id]

  target_groups_listener = {
    target-group2 = {
      port        = 80
      protocol    = "TCP"
      target_type = "instance"
      listeners = {
        port = 80
      }
      targets = []
    }
  }

  tags = local.tags
  org_name = "safemarch"
  project_name = "demo"
  env = "prod"
  region = "us-east-2"
}
