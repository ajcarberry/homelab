# =================================
# Module Outputs
# =================================

output "public_ip" {
  value = "${aws_instance.debian_ec2.*.public_ip}"
}

output "private_ip" {
  value = "${aws_instance.debian_ec2.*.private_ip}"
}
