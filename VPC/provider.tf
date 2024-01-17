terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.31.0" # AWS provider version, not terraform version
    }
  }

#give ur configuration for remote state file like below otherwise use ur local terraform.tfstate file only
#   backend "s3" {
#     bucket = "daws76s-remote-state"
#     key    = "vpc"
#     region = "us-east-1"
#     dynamodb_table = "daws76s-locking"
#   }
}

provider "aws" {
  region = "us-east-1"
}
