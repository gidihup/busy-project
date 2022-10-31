terraform {
  required_providers {
    aws = "~> 4.3.0"
  }

  backend "s3" {
    bucket = "terraform-backend-busayo"
    key    = "test/app-stack.tfstate"
    region = "us-east-2"
  }
}

provider "aws" {
  region = var.AWS_REGION
}