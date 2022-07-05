resource "aws_codeartifact_domain_permissions_policy" "domain__policy1" {
  domain          = aws_codeartifact_domain.domain1.domain
  policy_document = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "codeartifact:CreateRepository",
            "Effect": "Allow",
            "Principal": "*",
            "Resource": "${aws_codeartifact_domain.domain1.arn}"
        }
    ]
}
EOF
}


resource "aws_codeartifact_repository_permissions_policy" "repo_policy1" {
  repository      = "${local.secretariat}-${local.agency}-${local.environment}-codeartifact_repository-*"
  domain          = aws_codeartifact_domain.domain1.domain
  policy_document = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "codeartifact:CreateRepository",
            "Effect": "Allow",
            "Principal": "*",
            "Resource": "${local.secretariat}-${local.agency}-${local.environment}-codeartifact_repository-*" 
        }
    ]
}
EOF
}

/* Notes: M
Modify line 30 to point to the arn of the Domain
Domain in line 21 
Use the wildcard for 20 since we may have multiple Repos 
*/