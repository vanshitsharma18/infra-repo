include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../modules/iam-bindings"
}

inputs = {
  project_id = "devops-lab-498208"

  service_account_email = "github-actions-sa@devops-lab-498208.iam.gserviceaccount.com"

  roles = [
    "roles/artifactregistry.writer",
    "roles/run.admin",
    "roles/iam.serviceAccountUser",
    "roles/datastore.user"
  ]
}