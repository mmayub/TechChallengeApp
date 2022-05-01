terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 3.0"
    }
  }

  backend "s3" {
    bucket = "malik-terraform-backend"
    key = "terraform.tfstate"
    region = "ap-southeast-2"
  }
}

provider "aws" {
  profile = "default"
  region = "ap-southeast-2"
  access_key = var.aws-access-key
  secret_key = var.aws-secret-key 
}
