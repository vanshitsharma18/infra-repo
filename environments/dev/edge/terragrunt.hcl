include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../modules/edge"
}

inputs = {
  project_id = "devops-lab-498208"
  region     = "asia-south1"

  frontend_service_name = "incident-frontend"
  backend_service_name  = "incident-api"

  domain_name = "incident.vanshitsharma.me"
}