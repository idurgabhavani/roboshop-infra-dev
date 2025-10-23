terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "6.9.0" # AWS PROVIDER VERSION NOT THE TERRAFORM
    }
  }
  
  backend "s3" {
     bucket = "daws76s-remote-state25"
     key    = "openvpn" # our interst
     region = "us-east-1"
     dynamodb_table = "daws76s-locking"
   }
}





provider "aws" {
  region = "us-east-1"
}