terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}
provider "aws" {
  region  = "us-east-1"
  profile = var.default_aws_profile
}

resource "aws_s3_bucket" "remote_state" {
  bucket = var.remote_state_bucket
  lifecycle {
    prevent_destroy = true
  }

  tags = {
    Name  = var.remote_state_bucket
    Owner = var.owner
  }
}
resource "aws_s3_bucket_versioning" "remote_state" {
  bucket = aws_s3_bucket.remote_state.id
  versioning_configuration {
    status = "Enabled"
  }
}
resource "aws_s3_bucket_server_side_encryption_configuration" "remote_state" {
  bucket = aws_s3_bucket.remote_state.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}
resource "aws_dynamodb_table" "remote_state_lock" {
  name         = var.remote_state_lock_table_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
  lifecycle {
    prevent_destroy = true
  }

  tags = {
    Name  = var.remote_state_lock_table_name
    Owner = var.owner
  }
}
