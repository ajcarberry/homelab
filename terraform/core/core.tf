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

module "nat_subnet_1b" {
  source            = "../modules/common/aws/subnets/default_subnet"
  vpc               = "${module.vpc_default.vpc_id}"
  vpc_name          = "${module.vpc_default.vpc_name}"
  dmz_subnet        = "${module.dmz_subnet_1.dmz_subnet_id}"
  env               = "${terraform.workspace}"
  cidr              = "${lookup(var.nat_subnet_1b_cidr, terraform.workspace)}"
  availability_zone = "us-east-1a"
  tag               = "build"
}
