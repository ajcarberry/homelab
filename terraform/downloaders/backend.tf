terraform {
  backend "s3" {
    profile   = "default"
    region = "us-east-1"
    bucket = "homelab-terraform"
    key = "downloaders/state.tfstate"
    encrypt = true
  }
}
