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
  ami                         = "${data.aws_ami.debian.id}"
  instance_type               = "${var.instance_type}"
  subnet_id                   = "${var.subnet_id}"
  associate_public_ip_address = "${var.public_ip}"
  tags {
    Name          = "${var.name}_${var.env}"
    Environment   = "${var.env}"
    VPC           = "${var.vpc_name}"
    Automation    = "terraform"
    OS            = "debian"
    Base_AMI_Name = "${data.aws_ami.debian.name}"
  }
}
