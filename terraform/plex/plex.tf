data "aws_vpc" "plex_vpc" {

  state = "available"

  tags {
    Name = "main_vpc_${terraform.workspace}"
  }
}

data "aws_subnet" "plex_subnet" {

  vpc_id = "${data.aws_vpc.plex_vpc.id}"
  availability_zone = "us-east-1a"

  filter {
    name = "tag:Extra"
    values = ["DMZ"]
  }
}

data "aws_security_group" "plex_sg_default" {

  vpc_id = "${data.aws_vpc.plex_vpc.id}"

  filter {
    name = "tag:Name"
    values = ["homelab_default"]
  }
}

data "aws_security_group" "plex_sg_external" {

  vpc_id = "${data.aws_vpc.plex_vpc.id}"

  filter {
    name = "tag:Name"
    values = ["external_protected"]
  }
}

module "plex_host" {
  source            = "../modules/common/aws/ec2/ubuntu"
  vpc               = "${data.aws_vpc.plex_vpc.id}"
  vpc_name          = "${data.aws_vpc.plex_vpc.tags.Name}"
  env               = "${terraform.workspace}"
  subnet_id         = "${data.aws_subnet.plex_subnet.id}"
  public_ip         = "TRUE"
  instance_type     = "c5.xlarge"
  name              = "plex"
  instance_count    = 1
  security_groups   = [
    "${data.aws_security_group.plex_sg_default.id}",
    "${data.aws_security_group.plex_sg_external.id}",
    "${aws_security_group.sg_plex.id}"
  ]
  playbook          = "../../ansible/plex.yml"
}
