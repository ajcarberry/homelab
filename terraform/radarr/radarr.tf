data "aws_vpc" "radarr_vpc" {

  state = "available"

  tags = {
    Name = "main_vpc_${terraform.workspace}"
  }
}

data "aws_subnet" "radarr_subnet" {

  vpc_id = "${data.aws_vpc.radarr_vpc.id}"
  availability_zone = "us-east-1a"

  filter {
    name = "tag:Extra"
    values = ["DMZ"]
  }
}

data "aws_security_group" "radarr_sg_default" {

  vpc_id = "${data.aws_vpc.radarr_vpc.id}"

  filter {
    name = "tag:Name"
    values = ["homelab_default"]
  }
}

data "aws_security_group" "radarr_sg_external" {

  vpc_id = "${data.aws_vpc.radarr_vpc.id}"

  filter {
    name = "tag:Name"
    values = ["external_protected"]
  }
}

module "radarr_host" {
  source            = "../modules/common/aws/ec2/radarr"
  vpc               = "${data.aws_vpc.radarr_vpc.id}"
  vpc_name          = "${data.aws_vpc.radarr_vpc.tags.Name}"
  env               = "${terraform.workspace}"
  subnet_id         = "${data.aws_subnet.radarr_subnet.id}"
  public_ip         = true
  instance_type     = "t3.small"
  name              = "radarr"
  instance_count    = 1
  security_groups   = [
    "${data.aws_security_group.radarr_sg_default.id}",
    "${data.aws_security_group.radarr_sg_external.id}"
  ]
  playbook          = "../../ansible/radarr.yml"
  destroy           = "../../ansible/radarr_destroy.yml"
}
