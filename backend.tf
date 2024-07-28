terraform {
  backend "s3" {
    bucket         = "w7-ks-terra-8976"
    key            = "w10/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "locktable"
  }
}