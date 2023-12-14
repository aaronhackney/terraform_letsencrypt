variable "aws_region" {
  description = "aws region to create the environment"
  type        = string
}

variable "aws_access_key" {
  description = "AWS access key for IAM role with Route53 Permissions"
  type        = string
}
variable "aws_secret_key" {
  description = "AWS access secret key for IAM role with Route53 Permissions"
  type        = string
}

variable "email" {
  description = "email address to use with let's encrypt"
  type        = string
}

variable "domain_name" {
  description = "The base domain where we are creating new SSL certificates"
  type        = string
}

variable "rsa_key_bits" {
  description = "Size of the RSA Key to create"
  type        = number
}

variable "subject_alternative_names" {
  description = "SAN list"
  type        = list(string)
  default     = []
}

variable "common_names" {
  type = list(string)
}