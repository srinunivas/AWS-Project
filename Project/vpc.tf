#---------------------------------------------------
#                   VPC
#---------------------------------------------------
provider "aws" {
  region = "us-east-2"
}

module "vpc" {
  source = "../Modules/VPC"

  vpc_name = {
    Name = "project-vpc"
  }
  vpc_cidr_block = "172.0.0.0/16"
  igw_name = {
    Name = "project-vpc-igw"
  }
  public_subnet_name_1 = {
    Name = "project-vpc-public-subnet-1"
  }
  public_subnet_name_2 = {
    Name = "project-vpc-public-subnet-2"
  }
  public_subnet_name_3 = {
    Name = "project-vpc-public-subnet-3"
  }
  private_subnet_name_1 = {
    Name = "project-vpc-private-subnet-1"
  }
  private_subnet_name_2 = {
    Name = "project-vpc-private-subnet-2"
  }
  private_subnet_name_3 = {
    Name = "project-vpc-private-subnet-3"
  }
  public_rt_name = {
    Name = "project-vpc-public-rt"
  }
  private_rt_name = {
    Name = "project-vpc-private-rt"
  }
  public_subnet_1_cidr_block  = "172.0.1.0/24"
  public_subnet_2_cidr_block  = "172.0.2.0/24"
  public_subnet_3_cidr_block  = "172.0.3.0/24"
  private_subnet_1_cidr_block = "172.0.4.0/24"
  private_subnet_2_cidr_block = "172.0.5.0/24"
  private_subnet_3_cidr_block = "172.0.6.0/24"
  subnet_1_availability_zone  = "us-east-2a"
  subnet_2_availability_zone  = "us-east-2b"
  subnet_3_availability_zone  = "us-east-2c"

  eip_name = {
    Name = "project-vpc-eip"
  }

  nat_gateway_name = {
    Name = "project-vpc-nat"
  }
  route_table_cidr_block = "0.0.0.0/0"

  tags = local.tags
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