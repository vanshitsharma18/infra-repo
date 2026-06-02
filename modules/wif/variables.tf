variable "pool_id" {
  description = "Workload Identity Pool ID"
  type        = string
}

variable "provider_id" {
  description = "Workload Identity Provider ID"
  type        = string
}

variable "github_repositories" {
  description = "List of GitHub repositories allowed to authenticate"
  type        = list(string)
}

variable "service_account_email" {
  description = "Service Account Email"
  type        = string
}