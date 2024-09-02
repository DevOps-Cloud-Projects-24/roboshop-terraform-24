variable "name" {}
variable "instance_type" {}
variable "allow_port" {}
variable "allow_sg_cidr" {}
variable "subnet_ids" {}
variable "vpc_id" {}
variable "env" {}
variable "bastion_nodes" {}
variable "asg" {}
variable "vault_token" {}
variable "capacity" {
  default = {}
}
variable "zone_id" {}