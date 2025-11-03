module "route53" {
  source        = "../../modules/route53"
  env           = "staging"
  domain_name   = "https://vijaychandra.site"
  alb_dns_name  = module.ecs.alb_dns_name
  alb_zone_id   = data.aws_lb.main.zone_id
}
