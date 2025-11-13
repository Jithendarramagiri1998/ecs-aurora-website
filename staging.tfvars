env                  = "staging"
container_image      = "141559732042.dkr.ecr.us-east-1.amazonaws.com/mywebsite"
db_host              = "ecs-aurora-aurora-cluster-dev.cluster-cela4qmqgtmv.us-east-1.rds.amazonaws.com"
db_name              = "appdb"
db_username          = "admin"
db_password          = "MySecurePassword123!"
vpc_id               = "vpc-05299e9e75eab14c1"

# ✅ ALB needs at least two public subnets (different AZs)
public_subnet_ids    = [
  "subnet-096fd24cd2bfa60d6",  # ecs-aurora-public-1-dev (us-east-1a)
  "subnet-0488ea7a446fd6fdd"   # ecs-aurora-public-2-dev (us-east-1b)
]

# ✅ ECS tasks should run in private subnets
private_subnet_ids   = [
  "subnet-025488b679374292b",  # ecs-aurora-app-1-dev (us-east-1a)
  "subnet-0c6428f5e06768537"   # ecs-aurora-app-2-dev (us-east-1b)
]
