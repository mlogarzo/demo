#This roles will help us to associate EC2 instances to clusters, and other tasks.
data "aws_iam_policy_document" "tf_training_ecs" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

#role
resource "aws_iam_role" "tf_training_ecs_role" {
  name = "tf-training-ecs"
  assume_role_policy = data.aws_iam_policy_document.tf_training_ecs.json
}

#policy
resource "aws_iam_role_policy_attachment" "tf_training_ecs" {
  role       = aws_iam_role.tf_training_ecs_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

#instance profile
resource "aws_iam_instance_profile" "tf_training_ecs_instance_prof" {
  name = "tf-training-ecs"
  role = aws_iam_role.tf_training_ecs_role.name
}