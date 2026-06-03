include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../modules/cloud-run"
}

inputs = {
  service_name = "incident-api"

  region = "asia-south1"

  image = "asia-south1-docker.pkg.dev/devops-lab-498208/frontend-repo/incident-api:v2"

  service_account_email = "github-actions-sa@devops-lab-498208.iam.gserviceaccount.com"
}