data "aws_route53_zone" "base_domain" {
  name = var.domain_name
}

resource "tls_private_key" "private_key" {
  algorithm = "RSA"
  rsa_bits  = var.rsa_key_bits
}

resource "acme_registration" "registration" {
  account_key_pem = tls_private_key.private_key.private_key_pem
  email_address   = var.email
}

resource "acme_certificate" "certificate" {
  account_key_pem = acme_registration.registration.account_key_pem
  common_name     = var.common_name

  recursive_nameservers = ["ns-407.awsdns-50.com:53"]
  dns_challenge {
    provider = "route53"
    config   = {}
  }
  depends_on = [acme_registration.registration]
}

resource "local_file" "cert_chain" {
  content  = acme_certificate.certificate.certificate_pem
  filename = "${path.module}/${var.common_name}/${var.common_name}.pem"
}

resource "local_file" "private_key" {
  content  = acme_certificate.certificate.private_key_pem
  filename = "${path.module}/${var.common_name}/${var.common_name}.key"
}

resource "local_file" "issuer_pem" {
  content  = acme_certificate.certificate.issuer_pem
  filename = "${path.module}/${var.common_name}/ca.pem"
}

