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

module "vpc" {
  source             = "./vpc"
  name               = var.name
  cidr               = var.cidr
  private_subnets    = var.private_subnets
  public_subnets     = var.public_subnets
  availability_zones = var.availability_zones
  environment        = var.environment
}

module "security_groups" {
  source         = "./security-groups"
  name           = var.name
  vpc_id         = module.vpc.vpc_id
  environment    = var.environment
  container_port = var.container_port
}

module "alb" {
  source              = "./alb"
  name                = var.name
  vpc_id              = module.vpc.vpc_id
  subnets             = module.vpc.public_subnets
  environment         = var.environment
  security_groups     = [module.security_groups.alb]
  health_check_path   = var.health_check_path
  container_port      = var.container_port
}

module "rds" {
  source                    = "./rds"
  name                      = var.name
  environment               = var.environment
  master_username           = var.master_username
  master_password           = var.master_password
  availability_zones        = var.availability_zones
  db_security_groups        = [module.security_groups.db]
  db_subnet_group_name      =  module.vpc.db_subnet_group_name
}

