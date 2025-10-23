terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "6.9.0" # AWS PROVIDER VERSION NOT THE TERRAFORM
    }
  }
  
  backend "s3" {
     bucket = "daws76s-state-dev25"
     key    = "ec2-123" # our interst
     region = "us-east-1"
     dynamodb_table = "daws76s-locking-dev25"
   }
}





provider "aws" {
  region = "us-east-1"
}