# Getting AWS account ID so we don't enter it manually
data "aws_caller_identity" "current" {}

variable AWS_ACCOUNT_ID {
    default = data.aws_caller_identity.current.account_id
}

variable AWS_REGION {    
    default = "us-east-2"
}

variable AMI_ID {
  default = "ami-089a545a9ed9893b6"
}

variable EC2_USER {
  default = "ec2-user"
}