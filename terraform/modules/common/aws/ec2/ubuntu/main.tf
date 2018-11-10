# Ubuntu EC2
# =================================
# AMI Identification
# =================================
data "aws_ami" "ubuntu" {

  most_recent = true
  owners = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# EC2 Deployment
# =================================
resource "aws_instance" "web" {
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
  }
}
