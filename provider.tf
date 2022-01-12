terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "3.47.0"
    }
  }
}

provider "aws" {
  region = "eu-central-1"

  assume_role {
        role_arn = "arn:aws:iam::245443655115:role/sagemaker-latesflow-role"
    }
}
