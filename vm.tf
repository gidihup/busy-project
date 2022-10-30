resource "aws_security_group" "app-vm-sg" {
  name        = "app-vm-sg"
  description = "Allow inbound ssh access traffic VM app on port 8080"
  vpc_id      = aws_vpc.app-vpc.id
  
  # TODO: delete after testing
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "app-vm-sg"
  }
}

resource "aws_iam_instance_profile" "app-vm-iam" {
  name = "app-vm-instance-profile"
  role = aws_iam_role.app-vm-role.name
}

resource "aws_iam_role" "app-vm-role" {
  name = "app-vm-role"
  path = "/"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
               "Service": "ec2.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": "Allow read-write dynamodb"
        }
    ]
}
EOF
}

# Application VMs
resource "aws_instance" "app-vm-1" {
  ami                    = var.AMI_ID
  key_name               = "app-key"
  instance_type          = "t3.micro"
  availability_zone      = "us-east-2a"
  subnet_id              = aws_subnet.public-1
  vpc_security_group_ids = [aws_security_group.app-vm-sg.id]
  iam_instance_profile = aws_iam_instance_profile.app-vm-iam
  user_data = <<EOF
    #!/bin/bash
    echo "Cloning the flask app repo"
    EOF

  tags = {
    Name = "app-vm-1"
  }
}

resource "aws_instance" "app-vm-2" {
  ami                    = var.AMI_ID
  key_name               = "app-key"
  instance_type          = "t3.micro"
  availability_zone      = "us-east-2b"
  subnet_id              = aws_subnet.public-2
  vpc_security_group_ids = [aws_security_group.app-vm-sg.id]
  iam_instance_profile = aws_iam_instance_profile.app-vm-iam
  user_data = <<EOF
    #!/bin/bash
    echo "Cloning the flask app repo"
    EOF

  tags = {
    Name = "app-vm-2"
  }
}