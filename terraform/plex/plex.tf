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
    values = ["default"]
  }
}

module "plex_1" {
  source            = "../modules/common/aws/ec2/ubuntu"
  vpc               = "${data.aws_vpc.plex_vpc.id}"
  vpc_name          = "${data.aws_vpc.plex_vpc.tags.Name}"
  env               = "${terraform.workspace}"
  subnet_id         = "${data.aws_subnet.plex_subnet.id}"
  public_ip         = "FALSE"
  instance_type     = "c5.xlarge"
  name              = "plex"
}
