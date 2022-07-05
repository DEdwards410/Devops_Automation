resource "aws_codeartifact_domain" "testtting" {
  domain = "${local.secretariat}-${local.agency}-codeartifact-domain-${local.environment}-${local.domain_name}"

  tags = {
    "key" = "value"
    "key" = "value"
    "key" = "value"
  }
}
