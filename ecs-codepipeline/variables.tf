
locals {
  region   = data.aws_region.current.name
  deployment_config_name = ""
  appdetail = "21stCCLCAdmin DESE application"
  ecs_service_name ="eoe-dv-service-DESE.21stCCLCAdmin"
  termination_wait_time_in_minutes = 5
  ecs_cluster_name = "eoe-dev-cluster-DESE.21stCCLCAdmin"
  main_listener = ""
  main_target_group = ""
  test_target_group =""
  service_name = ""
  aws_account_id = 046175134037
  container_port = 443
  memory_reserv = 1024
  s3_key= ""
  s3_artifact_bucket = ""
  ecr_registery_name =  ""
  ecr_registery_tag= ""


 
 
  relative_path = replace(
    abspath(path.root),
    "/.+?(Deployed-EOE-.)/",
    "$1"
  )
##Tags Values
  application = "21CCLCAdmin"
  repo_name = "DESE.21stCCLCAdmin"
  secretariat = "eoe"
  businessowner = "Danielle.norton2@mass.gov"
  itowner = "eoe-dl-eoeawsalerts@mass.gov"
  agency = "edu"
  createdby = "smx"
  environment = "dev"
  groupname = "21stCCLCAdmin-poc"

  

}

# terraform {
#   backend "s3" {
#     bucket = ""
#     key    = "codepipeline/pipeline-eoe-dv-ecs_pipeline-21stCCLCAdmin-poc.tfstate"
#     region = "us-east-1"
#   }
# }