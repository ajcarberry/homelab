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
  tag               = "nat-build"
}

module "build_subnet" {
  source            = "../modules/common/aws/subnets/dmz_subnet"
  vpc               = "${module.vpc_default.vpc_id}"
  vpc_name          = "${module.vpc_default.vpc_name}"
  internet_gw       = "${module.vpc_default.internet_gateway_id}"
  env               = "${terraform.workspace}"
  cidr              = "${lookup(var.build_subnet_cidr, terraform.workspace)}"
  availability_zone = "us-east-1a"
  tag               = "dmz-build"
}

module "internal_subnet_1" {
  source            = "../modules/common/aws/subnets/internal_subnet"
  vpc               = "${module.vpc_default.vpc_id}"
  vpc_name          = "${module.vpc_default.vpc_name}"
  env               = "${terraform.workspace}"
  cidr              = "${lookup(var.internal_subnet_1_cidr, terraform.workspace)}"
  availability_zone = "us-east-1a"
  tag               = "internal"
}

resource "aws_efs_file_system" "shared_efs" {
  tags {
    Name          = "shared_efs"
    Environment   = "${terraform.workspace}"
    VPC           = "${module.vpc_default.vpc_name}"
    Automation    = "terraform"
  }
}

resource "aws_efs_mount_target" "shared_efs_mnt" {
  file_system_id  = "${aws_efs_file_system.shared_efs.id}"
  subnet_id       = "${module.internal_subnet_1.internal_subnet_id}"
  security_groups = ["${aws_security_group.sg_homelab_default.id}"]
}
