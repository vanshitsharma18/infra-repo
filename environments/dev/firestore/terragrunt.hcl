include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../modules/firestore"
}

inputs = {
  project_id = "devops-lab-498208"
  region     = "asia-south1"
}