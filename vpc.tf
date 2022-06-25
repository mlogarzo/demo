resource "aws_vpc" "tf_training_ecs_vpc" {
  cidr_block = "10.0.0.0/16"
  instance_tenancy = "default"
  enable_dns_hostnames = true
  tags = var.tags
}

#public subnet #1
resource "aws_subnet" "tf_training_ecs_subnet_a" {
  vpc_id = aws_vpc.tf_training_ecs_vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  tags = var.tags
}

#public subnet #2
resource "aws_subnet" "tf_training_ecs_subnet_b" {
  vpc_id = aws_vpc.tf_training_ecs_vpc.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-east-1b"
  tags = var.tags
}

#internet gateway
resource "aws_internet_gateway" "tf_training_ecs_gw" {
  vpc_id = aws_vpc.tf_training_ecs_vpc.id
  tags = var.tags
}

resource "aws_route_table" "tf_training_rt" {
  vpc_id = aws_vpc.tf_training_ecs_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.tf_training_ecs_gw.id
  }

  tags = var.tags
}

#associations
resource "aws_route_table_association" "tf_training_ass_a" {
  subnet_id      = aws_subnet.tf_training_ecs_subnet_a.id
  route_table_id = aws_route_table.tf_training_rt.id
}

resource "aws_route_table_association" "tf_training_ass_b" {
  subnet_id      = aws_subnet.tf_training_ecs_subnet_b.id
  route_table_id = aws_route_table.tf_training_rt.id
}