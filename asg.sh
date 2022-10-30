resource "aws_launch_template" "app-vm" {
  name_prefix   = "app-vm"
  image_id      = "ami-1a2b3c"
  instance_type = "t2.micro"
  iam_instance_profile {
    name = "app-vm-role"
  } 
}

resource "aws_autoscaling_group" "app-asg" {
  availability_zones = ["us-east-2a", "us-east-2b"]
  desired_capacity   = 2
  max_size           = 3
  min_size           = 0

  launch_template {
    id      = aws_launch_template.app-vm.id
    version = "$Latest"
  }
}