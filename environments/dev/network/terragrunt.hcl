include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../modules/network"
}

inputs = {
  vpc_name    = "dev-vpc"
  subnet_name = "dev-subnet"
  cidr        = "10.129.0.0/20"
  region      = "asia-south1"
}