locals {
  vpc_name              = { Name = "${var.org_name}-${var.project_name}-${var.env}-${var.region}-${var.vpc_name}" }
  igw_name              = { Name = "${var.org_name}-${var.project_name}-${var.env}-${var.region}-${var.igw_name}" }
  public_subnet_name_1  = { Name = "${var.org_name}-${var.project_name}-${var.env}-${var.region}-${var.public_subnet_name_1}" }
  public_subnet_name_2  = { Name = "${var.org_name}-${var.project_name}-${var.env}-${var.region}-${var.public_subnet_name_2}" }
  public_subnet_name_3  = { Name = "${var.org_name}-${var.project_name}-${var.env}-${var.region}-${var.public_subnet_name_3}" }
  private_subnet_name_1 = { Name = "${var.org_name}-${var.project_name}-${var.env}-${var.region}-${var.private_subnet_name_1}" }
  private_subnet_name_2 = { Name = "${var.org_name}-${var.project_name}-${var.env}-${var.region}-${var.private_subnet_name_2}" }
  private_subnet_name_3 = { Name = "${var.org_name}-${var.project_name}-${var.env}-${var.region}-${var.private_subnet_name_3}" }
  eip_name              = { Name = "${var.org_name}-${var.project_name}-${var.env}-${var.region}-${var.eip_name}" }
  nat_gateway_name      = { Name = "${var.org_name}-${var.project_name}-${var.env}-${var.region}-${var.nat_gateway_name}" }
  public_rt_name        = { Name = "${var.org_name}-${var.project_name}-${var.env}-${var.region}-${var.public_rt_name}" }
  private_rt_name       = { Name = "${var.org_name}-${var.project_name}-${var.env}-${var.region}-${var.private_rt_name}" }
}

# --------------------------------------------------------------------------------------------------------------------
# CREATE VPC
# --------------------------------------------------------------------------------------------------------------------
resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr_block
  tags       = merge(var.tags, local.vpc_name)
}
#--------------------------------------------------------------------------------------------------------------------
# CREATE IGW
# --------------------------------------------------------------------------------------------------------------------
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags   = merge(var.tags, local.igw_name)
}
resource "aws_default_vpc_dhcp_options" "default" {
  tags = { Name = "Default DHCP Option Set" }
}
resource "aws_vpc_dhcp_options_association" "dhcp" {
  vpc_id          = aws_vpc.vpc.id
  dhcp_options_id = aws_default_vpc_dhcp_options.default.id
}
# --------------------------------------------------------------------------------------------------------------------
# CREATE SUBNET
# --------------------------------------------------------------------------------------------------------------------
resource "aws_subnet" "pub-subnet-1" {
  vpc_id            = aws_vpc.vpc.id
  availability_zone = var.subnet_1_availability_zone
  cidr_block        = var.public_subnet_1_cidr_block
  tags              = merge(var.tags, local.public_subnet_name_1)
}

resource "aws_subnet" "pub-subnet-2" {
  vpc_id            = aws_vpc.vpc.id
  availability_zone = var.subnet_2_availability_zone
  cidr_block        = var.public_subnet_2_cidr_block
  tags              = merge(var.tags, local.public_subnet_name_2)
}

resource "aws_subnet" "pub-subnet-3" {
  vpc_id            = aws_vpc.vpc.id
  availability_zone = var.subnet_3_availability_zone
  cidr_block        = var.public_subnet_3_cidr_block
  tags              = merge(var.tags, local.public_subnet_name_3)
}

resource "aws_subnet" "pri-subnet-1" {
  vpc_id            = aws_vpc.vpc.id
  availability_zone = var.subnet_1_availability_zone
  cidr_block        = var.private_subnet_1_cidr_block
  tags              = merge(var.tags, local.private_subnet_name_1)
}

resource "aws_subnet" "pri-subnet-2" {
  vpc_id            = aws_vpc.vpc.id
  availability_zone = var.subnet_2_availability_zone
  cidr_block        = var.private_subnet_2_cidr_block
  tags              = merge(var.tags, local.private_subnet_name_2)
}

resource "aws_subnet" "pri-subnet-3" {
  vpc_id            = aws_vpc.vpc.id
  availability_zone = var.subnet_3_availability_zone
  cidr_block        = var.private_subnet_3_cidr_block
  tags              = merge(var.tags, local.private_subnet_name_3)
}


#---------------------------------------------------------------------------------------------------------------------
#create EIP and NAT gateway
#---------------------------------------------------------------------------------------------------------------------
resource "aws_eip" "eip-test" {
  #vpc        = true
  tags = merge(var.tags, local.eip_name)
}

resource "aws_nat_gateway" "nat_gateway" {
  subnet_id     = aws_subnet.pub-subnet-1.id
  allocation_id = aws_eip.eip-test.id
  tags          = merge(var.tags, local.nat_gateway_name)
}
# --------------------------------------------------------------------------------------------------------------------
# CREATE ROUTE TABLE
# --------------------------------------------------------------------------------------------------------------------
# Internet route tables
resource "aws_route_table" "public-RT" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = var.route_table_cidr_block
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = merge(var.tags, local.public_rt_name)
}
# NAT route tables
resource "aws_route_table" "nat-RT" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = var.route_table_cidr_block
    gateway_id = aws_nat_gateway.nat_gateway.id
  }

  tags = merge(var.tags, local.private_rt_name)
}
#-----------------------------------------------------------------------------------------------------------------------
#ASSOCIATING RT and SUBNETS
#-----------------------------------------------------------------------------------------------------------------------
resource "aws_route_table_association" "pub-RT-association1" {
  subnet_id      = aws_subnet.pub-subnet-1.id
  route_table_id = aws_route_table.public-RT.id
}

resource "aws_route_table_association" "pub-2-RT-association1" {
  subnet_id      = aws_subnet.pub-subnet-2.id
  route_table_id = aws_route_table.public-RT.id
}

resource "aws_route_table_association" "pub-3-RT-association1" {
  subnet_id      = aws_subnet.pub-subnet-3.id
  route_table_id = aws_route_table.public-RT.id
}

resource "aws_route_table_association" "pri-1-RT-association1" {
  subnet_id      = aws_subnet.pri-subnet-1.id
  route_table_id = aws_route_table.nat-RT.id
}

resource "aws_route_table_association" "pri-2-RT-association1" {
  subnet_id      = aws_subnet.pri-subnet-2.id
  route_table_id = aws_route_table.nat-RT.id
}

resource "aws_route_table_association" "pri-3-RT-association1" {
  subnet_id      = aws_subnet.pri-subnet-3.id
  route_table_id = aws_route_table.nat-RT.id
}