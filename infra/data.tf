# Getting AWS account ID so we don't enter it manually
data "aws_caller_identity" "current" {}