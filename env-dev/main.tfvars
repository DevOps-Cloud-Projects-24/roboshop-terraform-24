env = "dev"
bastion_nodes = ["172.31.84.76/32"]

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

ec2 = {
  frontend = {
    subnet_ref = "web"
    instance_type = "t3.small"
    allow_port   =  80
    allow_sg_cidr = ["10.10.0.0/24", "10.10.1.0/24"]
    capacity      = {
      desired_capacity = 1
      max          =  1
      min          =  1
    }
  }
}