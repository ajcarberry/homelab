# Route Table
# =================================
# Route table for DMZ Subnet
# =================================
resource "aws_route_table" "route_external" {
  count  = 3
  vpc_id = "${aws_vpc.vpc_internal_it.id}"

  tags {
    Name = "route_external_only_${count.index}_${var.env}"
    Env  = "${var.env}"
    VPC  = "${aws_vpc.vpc_internal_it.tags.Name}"
  }
}

resource "aws_route" "route_rule_external_only_gateway" {
  count  = 3
  route_table_id = "${element(aws_route_table.route_external_only.*.id, count.index)}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = "${aws_internet_gateway.internet_gw_public_it.id}"
}

# Subnet
# =================================
# DMZ subnets.
# =================================
resource "aws_subnet" "subnet_external" {
  count                   = 3
  vpc_id                  = "${aws_vpc.vpc_internal_it.id}"
  cidr_block              = "${lookup(var.cidr_class_b, var.env)}${lookup(var.vpc_subnets, format("external_%d", count.index))}"
  availability_zone       = "${lookup(var.azs, format("az_%d", count.index))}"
  map_public_ip_on_launch = false

  tags {
    Name = "subnet_external_${count.index}_${var.env}"
    Env  = "${var.env}"
    VPC  = "${aws_vpc.vpc_internal_it.tags.Name}"
  }
}
