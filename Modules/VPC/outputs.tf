output "public_subnet_id_1" {
  value = aws_subnet.pub-subnet-1.id
}

output "public_subnet_id_2" {
  value = aws_subnet.pub-subnet-2.id
}

output "public_subnet_id_3" {
  value = aws_subnet.pub-subnet-3.id
}

output "private_subnet_id_1" {
  value = aws_subnet.pri-subnet-1.id
}

output "private_subnet_id_2" {
  value = aws_subnet.pri-subnet-2.id
}

output "private_subnet_id_3" {
  value = aws_subnet.pri-subnet-3.id
}

output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "default_security_group_id" {
  value = aws_vpc.vpc.default_security_group_id
}