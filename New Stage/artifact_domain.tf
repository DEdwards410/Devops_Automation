resource "aws_codeartifact_domain" "domain1" {
  domain = "${local.secretariat}-${local.agency}-codeartifact-domain-${local.environment}-${local.domain_name}"

  tags = {
  application= local.application
  appdetail= local.appdetail
  secretariat = local.secretariat
  businessowner = local.businessowner
  itowner= local.itowner
  agency= local.agency
  createdby = local.createdby
  environment = local.environment
  groupname =local.groupname
  terraform_managed = "yes"
 tftemplatepath = "https://github.com/executive-office-of-education/CloudAdministration/tree/templates-terraform/${local.relative_path}"
  }
}