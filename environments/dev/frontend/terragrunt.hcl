include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../modules/cloud-run"
}

inputs = {
  service_name = "incident-frontend"

  region = "asia-south1"

  image = "asia-south1-docker.pkg.dev/devops-lab-498208/frontend-repo/incident-frontend:v1"

  service_account_email = "github-actions-sa@devops-lab-498208.iam.gserviceaccount.com"

  container_port = 8080
}