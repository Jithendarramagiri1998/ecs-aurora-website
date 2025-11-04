provider "aws" {
  region = "us-east-1"
}

module "vpc" {
  source = "../../modules/vpc"

  project_name        = "ecs-aurora"
  env                 = "dev"
  vpc_cidr            = "10.0.0.0/16"
  azs                 = ["us-east-1a", "us-east-1b"]
  public_subnets      = ["10.0.1.0/24", "10.0.2.0/24"]
  private_app_subnets = ["10.0.3.0/24", "10.0.4.0/24"]
  private_db_subnets  = ["10.0.5.0/24", "10.0.6.0/24"]
}

# Aurora Database Module
# Aurora Module
module "aurora" {
  source             = "../../modules/aurora"
  vpc_id             = module.vpc.vpc_id
  private_db_subnets = module.vpc.private_db_subnets
  ecs_sg_id          = aws_security_group.ecs_sg.id  # ✅ now from root
  project_name       = "myapp"
  env                = "dev"
  kms_key_arn        = aws_kms_key.aurora.arn
}

# ECS Module
module "ecs" {
  source             = "../../modules/ecs"
  env                = "dev"                              # ✅ Added
  vpc_id             = module.vpc.vpc_id
  public_subnet_ids  = module.vpc.public_subnet_ids        # ✅ Added
  private_subnet_ids = module.vpc.private_app_subnet_ids
  container_image    = "nginx:latest"
  db_host            = module.aurora.aurora_endpoint
  db_name            = "appdb"
  db_username        = "admin"
  db_password        = "MySecurePassword123!"
  
}

# Route53 DNS for dev environment
module "route53" {
  source       = "../../modules/route53"
  env          = "dev"
  domain_name  = "https://vijaychandra.site" # your actual domain
  alb_dns_name = module.ecs.alb_dns_name
  alb_zone_id  = module.ecs.alb_zone_id
}

# SNS Alerts
module "sns" {
  source      = "../../modules/sns"
  env         = "dev"
  alert_email = "alerts@mydomain.com"
}

# CloudWatch Monitoring
module "cloudwatch" {
  source           = "../../modules/cloudwatch"
  env              = "dev"
  ecs_cluster_name = module.ecs.cluster_name
  db_cluster_id    = module.aurora.db_cluster_id
  sns_topic_arn    = module.sns.topic_arn
  aws_region       = "us-east-1"   # ✅ Add this line
}
