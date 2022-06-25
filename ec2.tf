#key pair
resource "aws_key_pair" "tf_training_ecs" {
  key_name = var.key_name
  public_key = "${file("tf_training_ecs_rsa")}"
  
  tags = var.tags
}

data "aws_ami" "tf_training_ecs_ami" {
  most_recent = true
  owners = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-ecs-hvm-*-x86_64-ebs"]
  }
}

#launch template
resource "aws_launch_template" "tf_training_ecs_lt" {
  name          = "webserver"
  image_id      = data.aws_ami.tf_training_ecs_ami.id
  instance_type = var.instance_type
  iam_instance_profile {
    name = aws_iam_instance_profile.tf_training_ecs_instance_prof.name
  }
  vpc_security_group_ids = [aws_security_group.tf_training_ecs_asg.id]
  key_name = "${aws_key_pair.tf_training_ecs.key_name}"

  tag_specifications {
    resource_type = "instance"
    tags = var.tags
  }
  
  user_data = "${base64encode(file("associate-cluster.sh"))}"
}

#asg
resource "aws_autoscaling_group" "tf_training_ecs_asg" {
  name                 = "tf-training-ecs"
  vpc_zone_identifier  = [aws_subnet.tf_training_ecs_subnet_a.id, aws_subnet.tf_training_ecs_subnet_b.id]
  desired_capacity     = 2
  max_size             = 2
  min_size             = 1
  health_check_type = "ELB"
  force_delete = true

  target_group_arns=[aws_lb_target_group.tf_training_ecs_tg.arn]
  protect_from_scale_in = true

  launch_template {
    id      = aws_launch_template.tf_training_ecs_lt.id
    version = "$Latest"
  }
}