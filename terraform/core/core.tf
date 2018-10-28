#module "vpc" {
#  source    = "../modules/common/aws/vpc"
#  vpc_cidr      = "${lookup(var.vpc_cidr, terraform.workspace)}"
#  dmz_cidr  = "${lookup(var.dmz_cidr, terraform.workspace)}"
#  pub_cidr  = "${lookup(var.pub_cidr, terraform.workspace)}"
#  priv_cidr = "${lookup(var.priv_cidr, terraform.workspace)}"
#}
