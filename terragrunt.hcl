locals {
  project_id = "devops-lab-498208"
  region     = "asia-south1"
  environment = "dev"
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite"

  contents = <<EOF
provider "google" {
  project = "${local.project_id}"
  region  = "${local.region}"
}
EOF
}

remote_state {
  backend = "gcs"

  generate = {
    path      = "backend.tf"
    if_exists = "overwrite"
  }

  config = {
    bucket = "devops-lab-498208-tf-state"
    prefix = "${path_relative_to_include()}"
  }
}