#####Provider info goes here 
#####
#####


resource "aws_codeartifact_repository" "Java_Repo" {
  repository  = "${local.secretariat}-${local.agency}-${local.environment}-codeartifact_repository-Java"
  description = "Repisotiry for Java artifacts (Maven)"
  domain      = aws_codeartifact_domain.testtting.domain
  ##External connections will go here lets talk about it yay or nay
  tags = {
    "key" = "value"
    "key" = "value"
    "key" = "value"
  }
}


resource "aws_codeartifact_repository" "Nuget_Repo" {
  repository  = "${local.secretariat}-${local.agency}-${local.environment}-codeartifact_repository-Nuget"
  description = "Repisotiry for .Net packages (Nugut)"
  domain      = aws_codeartifact_domain.testtting.domain
  ##External connections will go here lets talk about it yay or nay

  tags = {
    "key" = "value"
    "key" = "value"
    "key" = "value"
  }
}

