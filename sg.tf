#security group
resource "aws_security_group" "tf_training_ecs_alb" {
  name        = "tf_training_ecs_alb"
  description = "Allow HTTP traffic to Load Balancer"
  vpc_id = aws_vpc.tf_training_ecs_vpc.id
  tags = var.tags
}

#ingress rule
resource "aws_security_group_rule" "tf_training_ecs_alb" {
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "all"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.tf_training_ecs_alb.id
}

#egress rule
resource "aws_security_group_rule" "tf_training_ecs_alb_2" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "all"
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "All egress traffic"
  security_group_id = aws_security_group.tf_training_ecs_alb.id
}

resource "aws_security_group" "tf_training_ecs_asg" {
  name        = "tf_training_ecs_asg"
  description = "Allow HTTP traffic to instances through Load Balancer"
  vpc_id = aws_vpc.tf_training_ecs_vpc.id
  tags = var.tags
}

#ingress rule
resource "aws_security_group_rule" "tf_training_ecs_asg" {
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "all"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.tf_training_ecs_asg.id
}

#egress rule
resource "aws_security_group_rule" "tf_training_ecs_asg_2" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "all"
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "All egress traffic"
  security_group_id = aws_security_group.tf_training_ecs_asg.id
}