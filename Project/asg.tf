#--------------------------------------------------------------------------------------
#                                    Auto Scaling Group & Launch Template
#--------------------------------------------------------------------------------------

module "aws_asg__launch_template" {
  source = "../Modules/ASG"

  launch_template_name                  = "sample-launch-template"
  ami_id                                = "ami-02bf8ce06a8ed6092"
  instance_type                         = "t2.micro"
  key_name                              = "ec2-key"
  ebs_device_name                       = "/dev/xvda"
  ebs_volume_size                       = 10
  network_interface_associate_public_ip = false
  associate_public_ip_address           = true
  delete_on_termination                 = true
  security_groups                       = [module.security_group.sg_id]
  subnet_id                             = module.vpc.public_subnet_id_1
  resource_type_tags                    = "instance"
  cw_monitoring                         = true
  tags = local.tags
  org_name = "safemarch"
  project_name = "demo"
  env = "prod"
  region = "us-east-2"

  asg_name                = "testing-asg"
  vpc_zone_identifier     = [module.vpc.public_subnet_id_1]
  asg_desired_capacity    = 2
  asg_max_size            = 2
  asg_min_size            = 2
  launch_template_id      = module.aws_asg__launch_template.launch_template_id
  launch_template_version = "$Latest"
  target_group_arns       = [module.network_load_balancer.target_group_arn["instance"]]
}
