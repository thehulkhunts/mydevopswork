output "vpc_id" {
  value = aws_vpc.eks_vpc.id
}

output "public_subnets" {
  value = element(aws_subnet.public_subnets.*.id, 0)
}

output "vpc_security_groups" {
  value = aws_security_group.vpc_sg.id
}