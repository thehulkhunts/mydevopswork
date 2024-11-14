resource "aws_vpc" "eks_vpc" {
  cidr_block = var.vpc_cidr
  instance_tenancy = "default"
  enable_dns_hostnames = true
  enable_dns_support = true

  tags = {
    Name = "eks_vpc"
    Environment = "dev"
  }

}

resource "aws_subnet" "public_subnets" {
  vpc_id = aws_vpc.eks_vpc.id

  count = length(var.public_subnets)
  cidr_block = element(var.public_subnets, count.index)
  availability_zone = element(var.availability_zones, count.index)
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnets"
    Environment = "dev"
  }
}

resource "aws_subnet" "private_subnets" {
  vpc_id = aws_vpc.eks_vpc.id

  count = length(var.private_subnets)
  cidr_block = element(var.private_subnets, count.index)
  availability_zone = element(var.availability_zones, count.index)
  map_public_ip_on_launch = false

  tags = {
    Name = "private_subnets"
    Environment = "dev"
  }
}

resource "aws_internet_gateway" "eks_vpc_igw" {
  vpc_id = aws_vpc.eks_vpc.id

  tags = {
    Name = "eks_vpc_igw"
    Environment = "dev"
  }
}
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.eks_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.eks_vpc_igw.id
  }
}
resource "aws_route_table_association" "public_rt_assoc" {
  route_table_id = aws_route_table.public_rt.id
  count = length(aws_subnet.public_subnets)
  subnet_id = element(aws_subnet.public_subnets.*.id, count.index)
}

resource "aws_eip" "eips" {
  count = 2
  depends_on = [ aws_internet_gateway.eks_vpc_igw ]
  tags = {
    Name = "elastic_ips"
    Environment = "dev"
  }
}
resource "aws_nat_gateway" "private_nats" {
  count = length(aws_eip.eips)
  allocation_id = element(aws_eip.eips.*.id, count.index)
  subnet_id = element(aws_subnet.public_subnets.*.id, count.index)
  depends_on = [ aws_internet_gateway.eks_vpc_igw ]

  tags = {
    Name = "nat gateways"
    Environment = "dev"
  }
}

resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.eks_vpc.id
  count = length(aws_nat_gateway.private_nats)
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = element(aws_nat_gateway.private_nats.*.id, count.index)
  }
}

resource "aws_route_table_association" "private_rt_assoc" {
  count = length(aws_route_table.private_route_table)
  subnet_id = element(aws_subnet.private_subnets.*.id, count.index)
  route_table_id = element(aws_route_table.private_route_table.*.id, count.index)
}

// specify some local variables here
locals {
  ingress_rules = [
    {
     port = 22
     description = "allow ssh ports"
     protocol = "tcp"
     cidr_blocks = ["0.0.0.0/0"]
    },
    {
      port = 8080
      description = "allow custom tcp port"
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      port = 8081
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "allow nexus artifact port"
    },
    {
      port = 9000
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "allow sonarqube port"
    },
    {
      port = 443
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "allow https port"
    }
  ]
  egress_rules = [
    {
      port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
      description = "allow external traffic"
    }
  ]
}
resource "aws_security_group" "vpc_sg" {
  vpc_id = aws_vpc.eks_vpc.id
  description = "allow ports to access instances"
  
  dynamic "ingress" {
    for_each = local.ingress_rules
    content {
      from_port = ingress.value.port
      to_port = ingress.value.port
      protocol = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
      description = ingress.value.description
    }
  }
  dynamic "egress" {
    for_each = local.egress_rules
    content {
      from_port = egress.value.port
      to_port = egress.value.port
      protocol = egress.value.porotocol
      description = egress.value.description
      cidr_blocks = egress.value.cidr_blocks
    }
  }
}
