module "route53" {
  source        = "../../modules/route53"
  env           = "staging"
  domain_name   = "myapp.example.com"
  alb_dns_name  = module.ecs.alb_dns_name
  alb_zone_id   = data.aws_lb.main.zone_id
}
