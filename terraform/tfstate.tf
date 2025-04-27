terraform {
  backend "s3" {
    encrypt = true
    region  = "us-east-1"
    bucket  = "microblog-tfstate"
    key     = "us-east-1/prod/terraform.tfstate"
  }
}
