aws-region                  = "ap-souteast-2"
name                        = "malik-app"
environment                 = "prod"
availability_zones          = ["ap-southeast-2a", "ap-southeast-2b", "ap-southeast-2c"]
cidr                        = "10.10.0.0/16"
public_subnets              = ["10.10.11.0/24", "10.10.12.0/24", "10.10.13.0/24"]
private_subnets             = ["10.10.1.0/24", "10.10.2.0/24", "10.10.3.0/24"]
app_count                   = 2
health_check_path           = "/healthcheck/"
app_port                    = 3000
tag                         = "latest"
container_cpu               = 1024
container_memory            = 2048
db_listen_host              = "0.0.0.0"
db_listen_port              = "3000"

# db_name                     = "postgres"
# ecs_task_execution_role_name= "myEcsTaskExecutionRole"
# ecs_auto_scale_role_name    = "myEcsAutoScaleRole"
# certificate_arn             = ""
# container_count             = "2"
# postgresql_instance_class   = "db.t3.medium"

# export envs for docker
# VTT_DBUSER=postgres
# VTT_DBPASSWORD=sEcure123
# VTT_DBNAME=app
# VTT_DBPORT=5432
# VTT_DBHOST=apprds.aws.techchallenge.com
# VTT_LISTENHOST=0.0.0.0
# VTT_LISTENPORT=3000

