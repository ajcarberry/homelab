module "vpc_default" {
  source    = "../modules/common/aws/vpc"
  cidr      = "${lookup(var.vpc_cidr, terraform.workspace)}"
  env       = "${terraform.workspace}"
  name      = "main_vpc"
}

module "dmz_subnet_1" {
  source            = "../modules/common/aws/subnets/dmz_subnet"
  vpc               = "${module.vpc_default.vpc_id}"
  vpc_name          = "${module.vpc_default.vpc_name}"
  internet_gw       = "${module.vpc_default.internet_gateway_id}"
  env               = "${terraform.workspace}"
  cidr              = "${lookup(var.dmz_subnet_1_cidr, terraform.workspace)}"
  availability_zone = "us-east-1a"
  tag               = "DMZ"
}

module "nat_subnet_1" {
  source            = "../modules/common/aws/subnets/default_subnet"
  vpc               = "${module.vpc_default.vpc_id}"
  vpc_name          = "${module.vpc_default.vpc_name}"
  dmz_subnet        = "${module.dmz_subnet_1.dmz_subnet_id}"
  env               = "${terraform.workspace}"
  cidr              = "${lookup(var.nat_subnet_1_cidr, terraform.workspace)}"
  availability_zone = "us-east-1a"
  tag               = "default"
}

module "build_subnet" {
  source            = "../modules/common/aws/subnets/dmz_subnet"
  vpc               = "${module.vpc_default.vpc_id}"
  vpc_name          = "${module.vpc_default.vpc_name}"
  internet_gw       = "${module.vpc_default.internet_gateway_id}"
  env               = "${terraform.workspace}"
  cidr              = "${lookup(var.build_subnet_cidr, terraform.workspace)}"
  availability_zone = "us-east-1a"
  tag               = "build"
}

module "bastion" {
  source            = "../modules/common/aws/ec2/debian"
  vpc               = "${module.vpc_default.vpc_id}"
  vpc_name          = "${module.vpc_default.vpc_name}"
  env               = "${terraform.workspace}"
  subnet_id         = "${module.dmz_subnet_1.dmz_subnet_id}"
  public_ip         = "TRUE"
  instance_type     = "t3.micro"
  name              = "bastion"
  instance_count    = 1
  security_groups   = [
    "${aws_security_group.sg_external_protected.id}",
    "${aws_security_group.sg_homelab_default.id}"
  ]
}

module "bastion_dns" {
  source            = "../modules/common/aws/r53/a"
  name              = "homelab-bastion-${terraform.workspace}"
  records           = "${module.bastion.public_ip}"
}
