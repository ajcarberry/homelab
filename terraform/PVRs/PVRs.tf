data "aws_vpc" "pvrs_vpc" {

  state = "available"

  tags {
    Name = "main_vpc_${terraform.workspace}"
  }
}

data "aws_subnet" "pvrs_subnet" {

  vpc_id = "${data.aws_vpc.pvrs_vpc.id}"
  availability_zone = "us-east-1a"

  filter {
    name = "tag:Extra"
    values = ["DMZ"]
  }
}

data "aws_security_group" "pvrs_sg_default" {

  vpc_id = "${data.aws_vpc.pvrs_vpc.id}"

  filter {
    name = "tag:Name"
    values = ["homelab_default"]
  }
}

data "aws_security_group" "pvrs_sg_external" {

  vpc_id = "${data.aws_vpc.pvrs_vpc.id}"

  filter {
    name = "tag:Name"
    values = ["external_protected"]
  }
}

module "pvrs_host" {
  source            = "../modules/common/aws/ec2/ubuntu"
  vpc               = "${data.aws_vpc.pvrs_vpc.id}"
  vpc_name          = "${data.aws_vpc.pvrs_vpc.tags.Name}"
  env               = "${terraform.workspace}"
  subnet_id         = "${data.aws_subnet.pvrs_subnet.id}"
  public_ip         = "TRUE"
  instance_type     = "t3.micro"
  name              = "pvrs"
  instance_count    = 1
  security_groups   = [
    "${data.aws_security_group.pvrs_sg_default.id}",
    "${data.aws_security_group.pvrs_sg_external.id}"
  ]
  playbook          = "../../ansible/PVRs.yml"
}
