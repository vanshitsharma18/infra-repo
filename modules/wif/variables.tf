variable "pool_id" {
  description = "Workload Identity Pool ID"
  type        = string
}

variable "provider_id" {
  description = "Workload Identity Provider ID"
  type        = string
}

variable "github_repository" {
  description = "GitHub repository in owner/repo format"
  type        = string
}

variable "service_account_email" {
  description = "Service account email"
  type        = string
}