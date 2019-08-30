terraform {
  backend "s3" {
    bucket  = "terraform-edu"
    region  = "eu-west-2"
    key     = "stage/services/frontend-app/terraform.tfstate"
    encrypt = true    
  }
}
