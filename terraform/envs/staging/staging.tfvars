# Environment
env = "staging"

# ECR image
container_image = "141559732042.dkr.ecr.us-east-1.amazonaws.com/mywebsite:v114-01d8468"

# Networking
vpc_id             = "vpc-05299e9e75eab14c1"
public_subnet_ids  = ["subnet-096fd24cd2bfa60d6", "subnet-0488ea7a446fd6fdd"]
private_subnet_ids = ["subnet-025488b679374292b", "subnet-0c6428f5e06768537"]

# Database (fill your actual details here)
db_host     = "ecs-aurora-aurora-cluster-dev.cluster-cela4qmqgtmv.us-east-1.rds.amazonaws.com"
db_name     = "appdb"
db_username = "admin"
db_password = "MySecurePassword123!"
