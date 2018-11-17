# Ubuntu EC2
# =================================
# AMI Identification
# =================================
data "aws_ami" "ubuntu" {

  most_recent = true
  owners = ["self"] #default profile

  filter {
    name   = "name"
    values = ["ubuntu-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# EC2 Deployment
# =================================
resource "aws_instance" "ubuntu_ec2" {
  ami                         = "${data.aws_ami.ubuntu.id}"
  instance_type               = "${var.instance_type}"
  subnet_id                   = "${var.subnet_id}"
  associate_public_ip_address = "${var.public_ip}"
  tags {
    Name          = "${var.name}_${var.env}"
    Environment   = "${var.env}"
    VPC           = "${var.vpc_name}"
    Automation    = "terraform"
    OS            = "ubuntu"
    Base_AMI_Name = "${data.aws_ami.ubuntu.name}"
  }
}
