variable "aws_profile" {
  default = {
    stage = "homelabStage"
    prod =  "homelabProd"
  }
}

variable "vpc_cidr" {
  default = {
    stage = "homelabStage"
    prod =  "homelabProd"
  }
}

variable "dmz_cidr" {
  default = {
    stage = "homelabStage"
    prod =  "homelabProd"
  }
}

variable "pub_cidr" {
  default = {
    stage = "homelabStage"
    prod =  "homelabProd"
  }
}

variable "priv_cidr" {
  default = {
    stage = "homelabStage"
    prod =  "homelabProd"
  }
}
