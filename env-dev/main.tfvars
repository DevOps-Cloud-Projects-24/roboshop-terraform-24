env = "dev"

vpc = {
  cidr               = "10.10.0.0/16"
  public_subnet      = ["10.10.0.0/24", "10.10.1.0/24"]
  web_subnet         = ["10.10.2.0/24", "10.10.3.0/24"]
  app_subnet         = ["10.10.4.0/24", "10.10.5.0/24"]
  db_subnet          = ["10.10.6.0/24", "10.10.7.0/24"]
  availability_zones = ["us-east-1a", "us-east-1b"]
  default_vpc_id     = "vpc-0f73a3e12eeaf6da2"
  default_vpc_rt     =  "rtb-08c850a505d04f17b"
  default_vpc_cidr   =  "172.31.0.0/16"
}