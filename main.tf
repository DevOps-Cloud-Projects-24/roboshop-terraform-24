module "vpc" {
  source = "./modules/vpc"

  cidr = var.vpc["cidr"]
  env = var.env
  public_subnet = var.vpc["public_subnet"]
  app_subnet = var.vpc["app_subnet"]
  web_subnet = var.vpc["web_subnet"]
  db_subnet = var.vpc["db_subnet"]
  availability_zones = var.vpc["availability_zonesm"]

}