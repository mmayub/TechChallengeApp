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
  az_count           = var.az_count
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
  vpc_id         = module.vpc.id
  environment    = var.environment
  container_port = var.container_port
}

module "alb" {
  source              = "./alb"
  name                = var.name
  vpc_id              = module.vpc.id
  subnets             = module.vpc.public_subnets
  environment         = var.environment
  security_groups     = [module.security_groups.alb]
  health_check_path   = var.health_check_path
  container_port      = var.container_port
  # certificate_arn     = var.certificate_arn
  # domain_name         = var.domain_name
}

module "ecr" {
  source      = "./ecr"
  name        = var.name
  tag         = var.tag
  environment = var.environment
}

module "ecs" {
  source                      = "./ecs"
  name                        = var.name
  environment                 = var.environment
  region                      = var.aws-region
  subnets                     = module.vpc.private_subnets
  aws_alb_target_group_arn    = module.alb.aws_alb_target_group_arn
  ecs_service_security_groups = [module.security_groups.ecs_tasks]
  container_port              = var.container_port
  # container_image             = var.container_image
  container_cpu               = var.container_cpu
  container_memory            = var.container_memory
  service_desired_count       = var.service_desired_count
  container_environment = [
    { 
      name = "LOG_LEVEL",
      value = "DEBUG" 
    },
    { 
      name = "PORT",
      value = var.container_port 
    }
  ]
  aws_ecr_repository_url = module.ecr.aws_ecr_repository_url
}

# module "rds" {
#   source                    = "./rds"
#   name                      = var.name
#   environment               = var.environment
#   # postgresql_version        = var.postgresql_version
#   master_username           = var.master_username
#   master_password           = var.master_password
#   availability_zones        = var.availability_zones
#   db_security_groups        = [module.security_groups.db]
#   postgresql_instance_class = var.postgresql_instance_class
# }











