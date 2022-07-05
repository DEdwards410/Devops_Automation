resource "aws_codeartifact_domain_permissions_policy" "test" {
  domain          = aws_codeartifact_domain.testtting.domain
  policy_document = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "codeartifact:CreateRepository",
            "Effect": "Allow",
            "Principal": "*",
            "Resource": "${aws_codeartifact_domain.testtting.arn}"
        }
    ]
}
EOF
}


resource "aws_codeartifact_repository_permissions_policy" "example" {
  repository      = "${local.secretariat}-${local.agency}-${local.environment}-codeartifact_repository-*"
  domain          = aws_codeartifact_domain.testtting.domain
  policy_document = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "codeartifact:CreateRepository",
            "Effect": "Allow",
            "Principal": "*",
            "Resource": "${aws_codeartifact_domain.testtting.arn}" 
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
