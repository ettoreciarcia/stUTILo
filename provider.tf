terraform {
  required_version = ">= 1.8.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.45.0"
    }
    archive = {
      source  = "hashicorp/archive"
      version = "2.4.2"
    }
  }
  backend "s3" {
    bucket = "terraform-state-project-ciarcia"
    key    = "stutilo.tfstate"
    region = "eu-west-1"
  }
}
