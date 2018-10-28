# Route Table
# =================================
# Route table for Public Subnet.
# =================================
resource "aws_route_table" "route_vpn_nat" {
  count  = 3
  vpc_id = "${aws_vpc.vpc_internal_it.id}"

  propagating_vgws = [
    "${aws_vpn_gateway.vpn_gw_internal_it.id}",
  ]

  tags {
    Name = "route_vpn_nat_${count.index}_${var.env}"
    Env  = "${var.env}"
    VPC  = "${aws_vpc.vpc_internal_it.tags.Name}"
  }
}

resource "aws_route" "route_rule_vpn_nat_gateway" {
  count = 3
  route_table_id = "${element(aws_route_table.route_vpn_nat.*.id, count.index)}"
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = "${element(aws_nat_gateway.nat_gw_public_it.*.id, count.index)}"
}

# Subnet
# =================================
# Public subnets.
# =================================
resource "aws_subnet" "subnet_public" {
  count                   = 3
  vpc_id                  = "${aws_vpc.vpc_internal_it.id}"
  cidr_block              = "${lookup(var.cidr_class_b, var.env)}${lookup(var.vpc_subnets, format("public_%d", count.index))}"
  availability_zone       = "${lookup(var.azs, format("az_%d", count.index))}"
  map_public_ip_on_launch = false

  tags {
    Name = "subnet_public_${count.index}_${var.env}"
    Env  = "${var.env}"
    VPC  = "${aws_vpc.vpc_internal_it.tags.Name}"
  }
}

resource "aws_route_table_association" "route_assoc_public" {
  count          = 3
  subnet_id      = "${element(aws_subnet.subnet_public.*.id, count.index)}"
  route_table_id = "${element(aws_route_table.route_vpn_nat.*.id, count.index)}"
}

# Gateway
# =================================
# NAT Gateway
# =================================
resource "aws_nat_gateway" "nat_gw_public_it" {
    count          = 3
    subnet_id      = "${element(aws_subnet.subnet_external.*.id, count.index)}"
    allocation_id  = "${element(aws_eip.nat_gw.*.id, count.index)}"
    depends_on     = ["aws_internet_gateway.internet_gw_public_it"]
}

# Elastic IP
# =================================
resource "aws_eip" "nat_gw" {
  count = 3
  vpc   = true
}
