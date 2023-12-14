terraform {
  required_version = "~> v1.5.7"

  required_providers {
    acme = {
      source  = "vancluever/acme"
      version = "~> 2.13.1"
    }
  }
}
provider "aws" {
  region     = var.aws_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

provider "acme" {
  # Staging for testing...
  # server_url = "https://acme-staging-v02.api.letsencrypt.org/directory"
  # Prod URL
  server_url = "https://acme-v02.api.letsencrypt.org/directory"
}
