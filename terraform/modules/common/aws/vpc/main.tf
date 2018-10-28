# =================================
# VPC
# =================================
resource "aws_vpc" "vpc_default" {
  cidr_block           = "${lookup(var.cidr_class_b, var.env)}.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags {
    Name = "vpc_internal_it_${var.env}"
    Env  = "${var.env}"
  }
}

# Gateway
# =================================
# Internet Gateway
# =================================
resource "aws_internet_gateway" "internet_gw_default" {
    vpc_id = "${aws_vpc.vpc_default.id}"

    tags {
      Name = "internet_gw_public_it_${var.env}"
      Env  = "${var.env}"
      VPC  = "${aws_vpc.vpc_default.tags.Name}"
    }
}
