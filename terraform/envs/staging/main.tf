module "ecs" {
  source             = "../../modules/ecs"
  env                = var.env
  public_subnet_ids  = var.public_subnet_ids
  vpc_id             = var.vpc_id
  ...
}

module "route53" {
  source       = "../../modules/route53"
  env          = var.env
  domain_name  = "vijaychandra.site"
  alb_dns_name = module.ecs.alb_dns_name
  alb_zone_id  = module.ecs.alb_zone_id
}
