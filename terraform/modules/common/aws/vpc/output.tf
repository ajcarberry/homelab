# =================================
# Module Outputs
# =================================

output "vpc_id" {
  value = "${aws_vpc.vpc_default.id}"
}

output "internet_gateway_id" {
  value = "${aws_internet_gateway.internet_gw_default.id}"
}
