# Debian EC2
# =================================
# AMI Identification
# =================================
data "aws_ami" "debian" {

  most_recent = true
  owners = ["self"] #default profile

  filter {
    name   = "name"
    values = ["debian-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# EC2 Deployment
# =================================
resource "aws_instance" "debian_ec2" {
  count                       = "${var.instance_count}"
  ami                         = "${data.aws_ami.debian.id}"
  instance_type               = "${var.instance_type}"
  subnet_id                   = "${var.subnet_id}"
  vpc_security_group_ids      = ["${var.security_groups}"]
  associate_public_ip_address = "${var.public_ip}"
  tags {
    Name          = "${var.name}_${count.index+1}"
    Environment   = "${var.env}"
    VPC           = "${var.vpc_name}"
    Automation    = "terraform"
    OS            = "debian"
    Base_AMI_Name = "${data.aws_ami.debian.name}"
  }
}
