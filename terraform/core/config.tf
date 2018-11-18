provider "aws" {
  region    = "us-east-1"
  profile   = "${terraform.workspace}"
}

provider "aws" {
  alias   = "master"
  region  = "us-east-1"
  profile = "default"
}
