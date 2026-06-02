include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../modules/artifact-registry"
}

inputs = {
  repository_name = "frontend-repo"
  description     = "Frontend Docker Images"
  region          = "asia-south1"
}