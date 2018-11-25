# Homelab External IP space
# =================================
variable "homelab_external_nets" {
  description = "Homelab trusted external IP space"
  default     = "108.203.5.21/32,173.246.214.15/32"
}

# VPC and Subnet IP ranges
# =================================
variable "vpc_cidr" {
  default = {
    stage = "10.10.0.0/16"
    prod =  "10.100.0.0/16"
  }
}

variable "dmz_subnet_1_cidr" {
  default = {
    stage = "10.10.0.0/24"
    prod  = "10.100.0.0/24"
  }
}

variable "nat_subnet_1_cidr" {
  default = {
    stage = "10.10.16.0/24"
    prod  = "10.100.16.0/24"
  }
}

variable "internal_subnet_1_cidr" {
  default = {
    stage = "10.10.32.0/24"
    prod  = "10.100.32.0/24"
  }
}

variable "build_subnet_cidr" {
  default = {
    stage = "10.10.255.0/24"
    prod  = "10.100.255.0/24"
  }
}
