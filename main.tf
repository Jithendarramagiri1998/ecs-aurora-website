module "ecs" {
  source             = "../../modules/ecs"
  env                = var.env
  public_subnet_ids  = var.public_subnet_ids
  private_subnet_ids = var.private_subnet_ids
  vpc_id             = var.vpc_id
# DB details
  db_host     = var.db_host
  db_name     = var.db_name
  db_username = var.db_username
  db_password = var.db_password

  # Container image to deploy
  container_image = var.container_image

}

module "route53" {
  source       = "../../modules/route53"
  env          = var.env
  domain_name  = "vijaychandra.site"
  alb_dns_name = module.ecs.alb_dns_name
  alb_zone_id  = module.ecs.alb_zone_id
}
