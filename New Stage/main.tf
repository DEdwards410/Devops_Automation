




resource "aws_codeartifact_domain" "domain1" {
  domain = "${local.secretariat}-${local.agency}-codeartifact-domain-${local.environment}-${local.domain_name}"

  tags = {
    application       = local.application
    appdetail         = local.appdetail
    secretariat       = local.secretariat
    businessowner     = local.businessowner
    itowner           = local.itowner
    agency            = local.agency
    createdby         = local.createdby
    environment       = local.environment
    groupname         = local.groupname
    terraform_managed = "yes"
    tftemplatepath    = "https://github.com/executive-office-of-education/CloudAdministration/tree/templates-terraform/${local.relative_path}"
  }
}

resource "aws_codeartifact_repository" "Java_Repo" {
  repository  = "${local.secretariat}-${local.agency}-codeartifact_repository-${local.environment}-${local.Java}"
  description = local.repo1_description
  domain      = aws_codeartifact_domain.domain1.domain
  ##External connections will go here lets talk about it yay or nay
  tags = {
    application       = local.application
    appdetail         = local.appdetail
    secretariat       = local.secretariat
    businessowner     = local.businessowner
    itowner           = local.itowner
    agency            = local.agency
    createdby         = local.createdby
    environment       = local.environment
    groupname         = local.groupname
    terraform_managed = "yes"
    tftemplatepath    = "https://github.com/executive-office-of-education/CloudAdministration/tree/templates-terraform/${local.relative_path}"
  }
}



resource "aws_codeartifact_repository" "Nuget_Repo" {
  repository  = "${local.secretariat}-${local.agency}-codeartifact_repository-${local.environment}-${local.Nuget}"
  description = local.repo2_description
  domain      = aws_codeartifact_domain.domain1.domain

  tags = {
    application       = local.application
    appdetail         = local.appdetail
    secretariat       = local.secretariat
    businessowner     = local.businessowner
    itowner           = local.itowner
    agency            = local.agency
    createdby         = local.createdby
    environment       = local.environment
    groupname         = local.groupname
    terraform_managed = "yes"
    tftemplatepath    = "https://github.com/executive-office-of-education/CloudAdministration/tree/templates-terraform/${local.relative_path}"
  }
}
