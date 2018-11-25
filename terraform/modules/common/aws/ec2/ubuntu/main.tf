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
  count                       = "${var.instance_count}"
  ami                         = "${data.aws_ami.ubuntu.id}"
  instance_type               = "${var.instance_type}"
  subnet_id                   = "${var.subnet_id}"
  vpc_security_group_ids      = ["${var.security_groups}"]
  associate_public_ip_address = "${var.public_ip}"
  tags {
    Name          = "${var.instance_count > 1 ? format("%s_%d", var.name, count.index+1) : var.name}"
    Environment   = "${var.env}"
    VPC           = "${var.vpc_name}"
    Automation    = "terraform"
    OS            = "ubuntu"
    Base_AMI_Name = "${data.aws_ami.ubuntu.name}"
  }

  provisioner "local-exec" {
    command = "${var.playbook == "" ? "sleep 120; ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i aws_instance.ubuntu_ec2.public_ip, var.playbook" : "sleep 120"}"
  }

  lifecycle {
    ignore_changes = ["ami"]
  }
}
