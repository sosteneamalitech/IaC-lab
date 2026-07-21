terraform {
    required_providers {
        aws = {
            source  = "hashicorp/aws"
            version = "~> 6.0"
        }
    }
    backend "s3" {
        bucket ="sostene-amalitech-remote-state"
        key    = "terraform.tfstate"
        region = "us-east-1"
        encrypt = true
        dynamodb_table = "sostene-amalitech-remote-state-lock"
        profile = "sostene.amalitech" # The AWS profile to use for authentication. This should match the profile configured in your AWS CLI.
    }
}
provider "aws" {
    region  = "us-east-1"
    profile = var.default_aws_profile
}
