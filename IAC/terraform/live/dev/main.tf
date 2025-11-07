#modulo computo

module "compute" {
source = "../../modules/compute"
project = var.project
environment = var.environment
vpc_id = module.network.vpc_id
public_subnets = module.network.public_subnet_ids
private_subnets = module.network.private_subnet_ids
alb_sg_id = module.security.alb_sg_id
ecs_sg_id = module.security.ecs_sg_id
service_name = var.service_name
container_port = var.container_port
desired_count = var.desired_count

#roles e imagenes
task_role_arn = module.iam.task_role_arn
execution_role_arn = module.iam.execution_role_arn
container_image = module.ecr.repository_url != null ? "${module.ecr.repository_url}:latest" : "public.ecr.aws/nginx/nginx:latest"
db_secret_arn = module.secrets.db_secret_arn
}

#modulo base de datos

module "database" {
source = "../../modules/database"
project = var.project
environment = var.environment
vpc_id = module.network.vpc_id
db_subnet_ids = module.network.db_subnet_ids
db_engine = var.db_engine
min_capacity = var.db_min_capacity
max_capacity = var.db_max_capacity
db_sg_id = module.security.db_sg_id
}

#modulo redes

module "network" {
source = "../../modules/network"
project = var.project
environment = var.environment
aws_region = var.aws_region
vpc_cidr = var.vpc_cidr
public_subnets = var.public_subnets
private_subnets = var.private_subnets
}


#modulo observabilidad

module "observability" {
source = "../../modules/observability"
project = var.project
environment = var.environment
alb_arn = module.compute.alb_arn
ecs_service_arn = module.compute.ecs_service_arn
enable_waf = var.enable_waf
}

#modulo seguridad

module "security" {
source = "../../modules/security"
project = var.project
environment = var.environment
vpc_id = module.network.vpc_id
alb_subnet_ids = module.network.public_subnet_ids
ecs_subnet_ids = module.network.private_subnet_ids
db_subnet_ids = module.network.db_subnet_ids
container_port = var.container_port
}

# modulo de roles
module "iam" {
source = "../../modules/iam"
project = var.project
environment = var.environment
}

# modulo de repositorios
module "ecr" {
source = "../../modules/ecr"
project = var.project
environment = var.environment
repo_name = var.ecr_repo_name
}

#modulo de secretos
module "secrets" {
source = "../../modules/secrets"
project = var.project
environment = var.environment
db_secret_name = var.db_secret_name
kms_key_alias = var.kms_key_alias
}

# modulo de redis

module "redis" {
  source             = "../../modules/redis"
  project            = var.project
  environment        = var.environment
  vpc_id             = module.network.vpc_id
  subnet_ids         = module.network.private_subnet_ids
  security_group_id  = module.security.redis_sg_id
  node_type          = "cache.t3.micro"
  num_cache_nodes    = 1
  auth_token         = null  # o usa un secreto
}