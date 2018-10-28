terraform {
  backend "s3" {
    region = "us-east-1"
    bucket = "homelab-terraform"
    key = "state/state.tfstate"
    encrypt = true
  }
}
