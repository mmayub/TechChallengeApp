terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 3.0"
    }
  }

  backend "s3" {
    bucket = "malikk-terraform-backend"
    key = "terraform.tfstate"
    region = "ap-southeast-2"
    # region = "us-east-1"
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
  app_port = var.app_port
}

module "alb" {
  source              = "./alb"
  name                = var.name
  vpc_id              = module.vpc.vpc_id
  subnets             = module.vpc.public_subnets
  environment         = var.environment
  security_groups     = [module.security_groups.alb]
  health_check_path   = var.health_check_path
  app_port            = var.app_port
}

module "rds" {
  source                    = "./rds"
  name                      = var.name
  environment               = var.environment
  db_username               = var.db_username
  db_password               = var.db_password
  availability_zones        = var.availability_zones
  db_security_groups        = [module.security_groups.db]
  db_subnet_group_name      =  module.vpc.db_subnet_group_name
}

module "route53" {
  source      = "./route53"
  vpc_id      = module.vpc.vpc_id
  rds_record_name     = module.rds.rds_instance_address
}

module "ecr" {
  source      = "./ecr"
  name        = var.name
  environment = var.environment
  tag         = var.tag
}

module "ecs" {
  source = "./ecs"
  container_cpu         = var.container_cpu
  container_memory      = var.container_memory
  container_port        = var.container_port
  service_desired_count = var.service_desired_count
  rds_endpoint          = module.route53.rds_record_name
  db_password           = var.db_password
  db_username           = var.db_username
  db_listen_host        = var.db_listen_host
  db_listen_port        = var.db_listen_port
  db_user               = var.db_user
}