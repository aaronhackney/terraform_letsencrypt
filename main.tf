data "aws_route53_zone" "base_domain" {
  name = var.domain_name
}

resource "tls_private_key" "private_key" {
  count     = length(var.common_names)
  algorithm = "RSA"
  rsa_bits  = var.rsa_key_bits
}

resource "acme_registration" "registration" {
  count           = length(var.common_names)
  account_key_pem = tls_private_key.private_key[count.index].private_key_pem
  email_address   = var.email
}


resource "acme_certificate" "certificate" {
  count                     = length(var.common_names)
  account_key_pem           = acme_registration.registration[count.index].account_key_pem
  common_name               = var.common_names[count.index]
  subject_alternative_names = var.subject_alternative_names


  recursive_nameservers = ["ns-407.awsdns-50.com:53"]
  dns_challenge {
    provider = "route53"
    config   = {}
  }
}

resource "local_file" "cert_chain" {
  count    = length(var.common_names)
  content  = acme_certificate.certificate[count.index].certificate_pem
  filename = "${path.module}/certificates/${var.common_names[count.index]}/${var.common_names[count.index]}.pem"
}

resource "local_file" "private_key" {
  count    = length(var.common_names)
  content  = acme_certificate.certificate[count.index].private_key_pem
  filename = "${path.module}/certificates/${var.common_names[count.index]}/${var.common_names[count.index]}.key"
}

resource "local_file" "issuer_pem" {
  count    = length(var.common_names)
  content  = acme_certificate.certificate[count.index].issuer_pem
  filename = "${path.module}/certificates/${var.common_names[count.index]}/ca.pem"
}
