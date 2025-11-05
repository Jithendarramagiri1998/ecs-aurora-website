variable "env" {
  description = "Environment name (dev, staging, prod)"
  type        = string
  default     = "staging"
}
variable "container_image" {
  description = "ECR image URI"
  type        = string
}

variable "vpc_id" {}
variable "public_subnet_ids" {}
variable "private_subnet_ids" {}
variable "db_host" {}
variable "db_name" {}
variable "db_username" {}
variable "db_password" {}