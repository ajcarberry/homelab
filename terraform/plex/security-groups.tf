# Security groups
# =================================
# SG for Plex
# =================================
resource "aws_security_group" "sg_plex" {
  name        = "sg_plex"
  description = "A SG allowing access to all Plex ports"
  vpc_id      = "${data.aws_vpc.plex_vpc.id}"

  tags = {
    Name = "plex"
    Env  = "${terraform.workspace}"
    VPC  = "${data.aws_vpc.plex_vpc.tags.Name}"
    Automation = "terraform"
  }
  ingress {
    protocol  = "tcp"
    from_port = 443
    to_port   = 443
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }
  ingress {
    protocol  = "tcp"
    from_port = 32400
    to_port   = 32400
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }
  ingress {
    protocol  = "udp"
    from_port = 1900
    to_port   = 1900
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }
  ingress {
    protocol  = "tcp"
    from_port = 3005
    to_port   = 3005
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }
  ingress {
    protocol  = "udp"
    from_port = 5353
    to_port   = 5353
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }
  ingress {
    protocol  = "tcp"
    from_port = 8324
    to_port   = 8324
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }
  ingress {
    protocol  = "udp"
    from_port = 32410
    to_port   = 32414
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }
  ingress {
    protocol  = "tcp"
    from_port = 32469
    to_port   = 32469
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }
}
