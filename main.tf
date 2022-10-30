terraform {
  required_providers {
    aws = "~> 4.3.0"
  }
}

provider "aws" {
  region = var.AWS_REGION
}