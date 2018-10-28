# Route Tables
# =================================
# Default route table
# =================================
resource "aws_route_table" "route_internal_only" {
  count  = 3
  vpc_id = "${aws_vpc.vpc_internal_it.id}"

  tags {
    Name = "route_vpn_only_${count.index}_${var.env}"
    Env  = "${var.env}"
    VPC  = "${aws_vpc.vpc_internal_it.tags.Name}"
  }
}

# Subnet
# =================================
# Management subnet
# =================================
resource "aws_subnet" "subnet_mgmt" {
  count                   = 3
  vpc_id                  = "${aws_vpc.vpc_internal_it.id}"
  cidr_block              = "${lookup(var.cidr_class_b, var.env)}${lookup(var.vpc_subnets, format("mgmt_%d", count.index))}"
  availability_zone       = "${lookup(var.azs, format("az_%d", count.index))}"
  map_public_ip_on_launch = false

  tags {
    Name = "subnet_mgmt_${count.index}_${var.env}"
    Env  = "${var.env}"
    VPC  = "${aws_vpc.vpc_internal_it.tags.Name}"
  }
}

resource "aws_route_table_association" "route_assoc_mgmt" {
  count          = 3
  subnet_id      = "${element(aws_subnet.subnet_mgmt.*.id, count.index)}"
  route_table_id = "${element(aws_route_table.route_vpn_only.*.id, count.index)}"
}
