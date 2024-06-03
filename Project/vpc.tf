#---------------------------------------------------
#                   VPC
#---------------------------------------------------
provider "aws" {
  region = "us-east-2"
}

module "vpc" {
  source = "../Modules/VPC"

  vpc_name = "VPC"
  vpc_cidr_block = "172.0.0.0/16"
  igw_name = "IGW"
  public_subnet_name_1 = "Public-Subnet-001"
  public_subnet_name_2 = "Public-Subnet-002"
  public_subnet_name_3 = "Public-Subnet-003"
  private_subnet_name_1 = "Private-Subnet-001"
  private_subnet_name_2 = "Private-Subnet-002"
  private_subnet_name_3 = "Private-Subnet-003"
  public_rt_name = "Public-RT"
  private_rt_name = "Private-RT"
  public_subnet_1_cidr_block  = "172.0.1.0/24"
  public_subnet_2_cidr_block  = "172.0.2.0/24"
  public_subnet_3_cidr_block  = "172.0.3.0/24"
  private_subnet_1_cidr_block = "172.0.4.0/24"
  private_subnet_2_cidr_block = "172.0.5.0/24"
  private_subnet_3_cidr_block = "172.0.6.0/24"
  subnet_1_availability_zone  = "us-east-2a"
  subnet_2_availability_zone  = "us-east-2b"
  subnet_3_availability_zone  = "us-east-2c"

  eip_name = "VPC-EIP"


  nat_gateway_name = "VPC-NAT"

  route_table_cidr_block = "0.0.0.0/0"

  tags = local.tags
  org_name = "safemarch"
  project_name = "demo"
  env = "prod"
  region = "us-east-2"
}

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnet_id_1" {
  value = module.vpc.public_subnet_id_1
}

output "public_subnet_id_2" {
  value = module.vpc.public_subnet_id_2
}

output "public_subnet_id_3" {
  value = module.vpc.public_subnet_id_3
}

output "private_subnet_id_1" {
  value = module.vpc.private_subnet_id_1
}

output "private_subnet_id_2" {
  value = module.vpc.private_subnet_id_2
}

output "private_subnet_id_3" {
  value = module.vpc.private_subnet_id_3
}

output "default_security_group_id" {
  value = module.vpc.default_security_group_id
}