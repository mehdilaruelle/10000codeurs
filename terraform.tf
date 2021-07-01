terraform {
  # Remove the block below if you do not use S3 as a backend
  backend "s3" {
    bucket = "mlaruelle-terraform-backend"
    key    = "codeurs.tfstate"
    region = "eu-west-3"
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.47.0"
    }
  }
}
