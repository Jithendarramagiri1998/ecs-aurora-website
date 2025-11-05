module "route53" {
  source       = "../../modules/route53"
  env          = var.env
  domain_name  = "vijaychandra.site"
  alb_dns_name = aws_lb.ecs_alb.dns_name
  alb_zone_id  = aws_lb.ecs_alb.zone_id
}
