# GCP Platform Infrastructure

Enterprise-grade Infrastructure-as-Code (IaC) for deploying a scalable, secure incident management platform on Google Cloud Platform using Terraform and Terragrunt.

## 📋 Table of Contents

- [Overview](#overview)
- [Architecture](#architecture)
- [Related Repositories](#related-repositories)
- [Prerequisites](#prerequisites)
- [Project Structure](#project-structure)
- [Environment Configuration](#environment-configuration)
- [Deployment](#deployment)
- [CI/CD Pipeline](#cicd-pipeline)
- [Modules](#modules)
- [Security](#security)
- [Troubleshooting](#troubleshooting)
- [Contributing](#contributing)
- [License](#license)

## 🏗️ Overview

This repository contains infrastructure code for deploying a multi-environment (Dev, Stage, Prod) incident management platform on GCP. The platform leverages Cloud Run for serverless compute, Cloud Firestore for data persistence, and Cloud Artifact Registry for container management, all protected behind an HTTPS load balancer with IAP.

**Key Features:**
- ✅ Multi-environment support (dev, stage, prod)
- ✅ HTTPS load balancing with Cloud Run integration
- ✅ Identity-Aware Proxy (IAP) for secure access
- ✅ Managed SSL certificates with auto-renewal
- ✅ Firestore database provisioning
- ✅ VPC network isolation
- ✅ Artifact Registry for container images
- ✅ Service account and IAM management
- ✅ Workload Identity Federation (WIF) support
- ✅ Remote state management with GCS backend

## 🎯 Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    Internet Traffic                         │
└────────────────────────┬────────────────────────────────────┘
                         │
                    [HTTPS Load Balancer]
                    incident-https-forwarding-rule
                         │
         ┌───────────────┴───────────────┐
         │                               │
    [Frontend Service]              [API Service]
    (incident-frontend)            (incident-api)
    Cloud Run (Serverless)       Cloud Run (Serverless)
         │                               │
         └───────────────┬───────────────┘
                         │
                  [Cloud Firestore]
                  (Incident Data Store)
                         │
              [VPC Network - asia-south1]
```

## � Related Repositories

This infrastructure repository is part of a larger incident management platform. Check out the application repositories:

- **[Backend Repository](https://github.com/vanshitsharma18/backend-repo)** - REST API and backend services
- **[Frontend Repository](https://github.com/vanshitsharma18/frontend-repo)** - React frontend application

These repositories contain the containerized applications that are deployed to the Cloud Run services managed by this infrastructure.

## �📦 Prerequisites

### Required Tools

- **Terraform** v1.8.5 or higher
- **Terragrunt** v0.76.6 or higher
- **Google Cloud SDK** (gcloud CLI)
- **Kubectl** (for Kubernetes operations, optional)
- **Git** v2.30 or higher

### GCP Setup

```bash
# Install Google Cloud SDK
# https://cloud.google.com/sdk/docs/install

# Authenticate with GCP
gcloud auth application-default login

# Set your project
gcloud config set project devops-lab-498208

# Enable required APIs
gcloud services enable \
  compute.googleapis.com \
  run.googleapis.com \
  firestore.googleapis.com \
  artifactregistry.googleapis.com \
  servicenetworking.googleapis.com \
  iap.googleapis.com \
  iam.googleapis.com
```

### GCP Permissions

Ensure your service account has the following roles:
- `roles/compute.admin`
- `roles/run.admin`
- `roles/firestore.admin`
- `roles/artifactregistry.admin`
- `roles/iam.securityAdmin`
- `roles/storage.admin` (for remote state)

## 📁 Project Structure

```
gcp-platform-infra/
├── README.md                          # This file
├── terragrunt.hcl                     # Root Terragrunt configuration
├── .github/
│   └── workflows/
│       └── ci.yml                     # CI/CD Pipeline
├── environments/
│   ├── dev/                           # Development environment
│   │   ├── artifact-registry/
│   │   │   └── terragrunt.hcl
│   │   ├── edge/                      # Load Balancer & Networking
│   │   │   └── terragrunt.hcl
│   │   ├── firestore/
│   │   │   └── terragrunt.hcl
│   │   ├── iam-bindings/
│   │   │   └── terragrunt.hcl
│   │   ├── network/
│   │   │   └── terragrunt.hcl
│   │   ├── service-account/
│   │   │   └── terragrunt.hcl
│   │   ├── wif/
│   │   │   └── terragrunt.hcl
│   │   └── terragrunt.hcl
│   ├── stage/                         # Staging environment
│   │   └── terragrunt.hcl
│   └── prod/                          # Production environment
│       └── terragrunt.hcl
└── modules/
    ├── artifact-registry/             # Container Registry Module
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
    ├── edge/                          # Load Balancer & SSL Module
    │   ├── main.tf
    │   ├── variables.tf
    │   └── output.tf
    ├── firestore/                     # Database Module
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
    ├── iam-bindings/                  # IAM Roles Module
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
    ├── network/                       # VPC & Networking Module
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
    ├── service-account/               # Service Accounts Module
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
    └── wif/                           # Workload Identity Federation Module
        ├── main.tf
        ├── variables.tf
        └── outputs.tf
```

## 🔧 Environment Configuration

### Development Environment

The dev environment is configured for the `asia-south1` region:

- **Project ID:** `devops-lab-498208`
- **Region:** `asia-south1`
- **Frontend Service:** `incident-frontend`
- **Backend Service:** `incident-api`
- **Domain:** `incident.vanshitsharma.me`

### Customizing Environments

Edit `environments/{env}/edge/terragrunt.hcl` to modify environment-specific variables:

```hcl
inputs = {
  project_id            = "your-project-id"
  region                = "asia-south1"
  frontend_service_name = "incident-frontend"
  backend_service_name  = "incident-api"
  domain_name           = "incident.vanshitsharma.me"
}
```

## 🚀 Deployment

### Manual Deployment (Local Development)

1. **Initialize Terragrunt:**
   ```bash
   cd environments/dev
   terragrunt init
   ```

2. **Plan Infrastructure:**
   ```bash
   terragrunt plan
   ```

3. **Apply Infrastructure:**
   ```bash
   terragrunt apply
   ```

4. **Destroy Infrastructure (when needed):**
   ```bash
   terragrunt destroy
   ```

### Deploy Specific Module

```bash
cd environments/dev/edge
terragrunt apply
```

### Automated Deployment via GitHub Actions

The infrastructure is automatically deployed when the CI/CD pipeline is manually triggered:

1. Go to **Actions** tab in GitHub
2. Select **Infrastructure CI** workflow
3. Click **Run workflow** button
4. Select the desired branch (default: main)
5. Click **Run workflow**

The workflow will:
- ✅ Validate Terraform configuration
- ✅ Format check all HCL files
- ✅ Display infrastructure structure
- ✅ Deploy infrastructure to GCP

## 🔄 CI/CD Pipeline

### Workflow: Infrastructure CI (`ci.yml`)

The GitHub Actions workflow supports manual deployment to GCP infrastructure.

**Trigger:** Manual via `workflow_dispatch`

**Pipeline Steps:**
1. **Checkout Repository** - Clones the latest code
2. **Setup Terraform** - Installs Terraform v1.8.5
3. **Install Terragrunt** - Installs Terragrunt v0.76.6
4. **Show Terraform Version** - Displays Terraform version
5. **Show Terragrunt Version** - Displays Terragrunt version
6. **Terraform Format Check** - Validates HCL formatting
7. **Repository Structure** - Lists project files

### Deployment Workflow

When manually triggered, the pipeline validates and prepares the infrastructure for deployment to GCP. Follow the deployment process:

```bash
# Workflow validates configuration
# → Checks Terraform syntax
# → Verifies HCL formatting
# → Displays infrastructure structure
# → Ready for deployment approval
```

### Manual Trigger Instructions

To trigger deployment:

1. **Via GitHub Web UI:**
   - Navigate to Actions → Infrastructure CI → Run workflow

2. **Via GitHub CLI:**
   ```bash
   gh workflow run ci.yml -r main
   ```

3. **Via Git Push:**
   ```bash
   git push origin main
   ```

## 📦 Modules

### Edge (Load Balancer & SSL)
**Path:** `modules/edge/`

Provisions:
- Global static IP address
- Google-managed SSL certificates
- HTTPS load balancer
- Backend services for Cloud Run
- URL routing rules (/api/* → backend, / → frontend)
- HTTP → HTTPS redirect

**Key Resources:**
- `google_compute_global_address` - External IP
- `google_compute_managed_ssl_certificate` - SSL/TLS certificate
- `google_compute_backend_service` - Backend services
- `google_compute_url_map` - Request routing
- `google_compute_target_https_proxy` - HTTPS proxy
- `google_compute_global_forwarding_rule` - Listener rules

### Network
**Path:** `modules/network/`

Provisions:
- VPC network
- Subnets with private Google access
- Firewall rules

### Firestore
**Path:** `modules/firestore/`

Provisions:
- Firestore database (FIRESTORE_NATIVE mode)
- Database deletion protection

### Service Account
**Path:** `modules/service-account/`

Provisions:
- GCP service accounts
- Service account keys
- Role bindings

### IAM Bindings
**Path:** `modules/iam-bindings/`

Manages:
- Role assignments
- Service account permissions
- Cross-project access

### Artifact Registry
**Path:** `modules/artifact-registry/`

Provisions:
- Container image repositories
- Registry permissions

### Workload Identity Federation (WIF)
**Path:** `modules/wif/`

Enables:
- GitHub Actions authentication to GCP
- Keyless OIDC token exchange

## 🔐 Security

### Best Practices Implemented

- ✅ **SSL/TLS Encryption** - All traffic over HTTPS
- ✅ **IAP Authentication** - OAuth 2.0 based access control
- ✅ **Service Accounts** - Least privilege access
- ✅ **Network Isolation** - Private VPC networks
- ✅ **Workload Identity** - Keyless authentication for CI/CD
- ✅ **Remote State Encryption** - GCS backend with versioning
- ✅ **Managed Certificates** - Auto-renewal via Google

### Sensitive Data Management

Never commit secrets to the repository. Store sensitive information in:
- **Google Secret Manager** - For production secrets
- **GitHub Secrets** - For CI/CD credentials
- **`.tfvars` files** - Add to `.gitignore` for local development

## 🔍 Troubleshooting

### SSL Certificate Pending

New SSL certificates take 15-20 minutes to provision. Check status:

```bash
gcloud compute ssl-certificates describe incident-ssl-cert
```

### Health Check Failures

Ensure Cloud Run services are deployed and responding to HTTP requests on the expected port.

```bash
gcloud run services describe incident-frontend --region asia-south1
```

### Terragrunt Lock Issues

If you encounter lock files:

```bash
rm -rf .terragrunt-cache
rm -rf .terraform
terragrunt init
```

### GCS State Issues

Clear local state cache:

```bash
rm -rf .terraform
terragrunt init
```

### Backend Service Issues

Check backend service health:

```bash
gcloud compute backend-services get-health incident-frontend-backend --global
```

## 📊 Monitoring & Logging

Monitor your infrastructure:

```bash
# View Cloud Run logs
gcloud run services describe incident-frontend --region asia-south1

# View load balancer metrics
gcloud compute backend-services get-health incident-frontend-backend --global

# Check SSL certificate status
gcloud compute ssl-certificates list

# View Firestore statistics
gcloud firestore databases list
```

## 🤝 Contributing

1. Create a feature branch: `git checkout -b feature/module-name`
2. Make changes to terraform files
3. Format code: `terraform fmt -recursive`
4. Commit changes: `git commit -m "Description of changes"`
5. Push branch: `git push origin feature/module-name`
6. Submit a pull request
7. Merge after approval

### Code Standards

- Follow HCL naming conventions
- Add comments for complex logic
- Include variable descriptions
- Update outputs when adding resources
- Test changes locally before pushing

## 📝 License

This infrastructure code is proprietary and confidential.

## 📧 Support

For issues or questions:
- Create an issue in GitHub
- Contact the DevOps team

---

**Last Updated:** June 3, 2026  
**Terraform Version:** 1.8.5  
**Terragrunt Version:** 0.76.6
