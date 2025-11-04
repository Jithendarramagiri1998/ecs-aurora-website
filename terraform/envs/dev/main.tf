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
module "aurora" {
  source = "../../modules/aurora"

  project_name       = "ecs-aurora"
  env                = "dev"
  vpc_id             = module.vpc.vpc_id
  private_db_subnets = module.vpc.private_db_subnet_ids # ✅ correct output name
  ecs_sg_id          = "sg-08aff85c997bf7d9c"        # Replace after ECS SG creation
  kms_key_arn        = "arn:aws:kms:us-east-1:141559732042:key/mrk-4adac1a49f484a4f87354fd6b5574bf9"  # yoours kms_key_arn

  db_username = "admin"
  db_name     = "webappdb"
}

# ECS Fargate Service
module "ecs" {
  source             = "../../modules/ecs"
  env                = "dev"
  vpc_id             = module.vpc.vpc_id
  public_subnet_ids  = module.vpc.public_subnet_ids
  private_subnet_ids = module.vpc.private_app_subnet_ids # ✅ corrected
  container_image    = "nginx:latest"                    # Replace with your image
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
