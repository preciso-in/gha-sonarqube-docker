variable "GOOGLE_CREDENTIALS" {
  description = "The credentials to use for GCP. You can provide these in the TF Cloud"
  sensitive   = true
  default     = ""
  type        = string
}

variable "project_id" {
  default = "GHA-TFCloud-Vault"
  type    = string
}

variable "network_name" {
  default = "gasd-nw"
  type    = string
}

variable "subnet_name" {
  default = "gasd-subnet"
  type    = string
}

variable "region" {
  default     = "us-central1"
  description = "Region where the Project will be created"
  type        = string
}

variable "sonarqube_network_tag" {
  default = "scanner-server"
  type    = string
}
