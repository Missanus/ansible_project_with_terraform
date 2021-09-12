# AWS Provider Configuration
provider "aws" {
  #assume_role {     role_arn = local.deploy_role_arn }
  region = var.aws_region
  default_tags {
    tags = {

      BillingBusinessApp           = var.BillingBusinessApp
      traitev-bucket-repo          = var.repos_bucket 
      traitev-bucket-results       = var.repos_bucket_resultat
      server-name-env              = var.test_env
    }
  }
}


/*
terraform { 
  backend "s3" {
    }
  
}
*/