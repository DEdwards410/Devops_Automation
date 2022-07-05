#####Provider info goes here 
#####
#####


resource "aws_codeartifact_repository" "Java_Repo" {
  repository  = "${local.secretariat}-${local.agency}-${local.environment}-codeartifact_repository-Java"
  description = "Repisotiry for Java (Maven)"
  domain      = aws_codeartifact_domain.domain1.domain
  ##External connections will go here lets talk about it yay or nay
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


resource "aws_codeartifact_repository" "Nuget_Repo" {
  repository  = "${local.secretariat}-${local.agency}-${local.environment}-codeartifact_repository-Nuget"
  description = "Repisotiry for .Net (Nuget)"
  domain      = aws_codeartifact_domain.domain1.domain
  ##External connections will go here lets talk about it yay or nay

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
