
locals {




  domain_name       = "eoedomain"
  Nuget             = "Nuget"
  Java              = "Java"
  accountnumber     = ""
  region            = "us-east-1"
  repo1_description = "Repisotiry for Java (Maven)"
  repo2_description = "Repisotiry for .Net (Nuget)"






  relative_path = replace(
    abspath(path.root),
    "/.+?(Deployed-EOE-.)/",
    "$1"
  )
  ##Tags Values
  application   = ""
  appdetail     = ""
  secretariat   = "eoe"
  businessowner = "Danielle.norton2@mass.gov"
  itowner       = "eoe-dl-eoeawsalerts@mass.gov"
  agency        = "edu"
  createdby     = "smx"
  environment   = "dev"
  groupname     = ""

}



