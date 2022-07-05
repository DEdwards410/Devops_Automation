
locals {
 
  domain_name = "eoe-edu-dev-codeartifact-domain"
 



  relative_path = replace(
    abspath(path.root),
    "/.+?(Deployed-EOE-.)/",
    "$1"
  )
##Tags Values
  application = ""
  appdetail = ""
  secretariat = "eoe"
  businessowner = "Danielle.norton2@mass.gov"
  itowner = "eoe-dl-eoeawsalerts@mass.gov"
  agency = "edu"
  createdby = "smx"
  environment = "dev"
  groupname = ""
  
}