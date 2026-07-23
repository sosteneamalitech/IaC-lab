variable "remote_state_bucket" {
  description = "The name of the S3 bucket to store the remote state."
  default     = "sostene-amalitech-remote-state"
  type        = string
}
variable "remote_state_lock_table_name" {
  description = "The name of the DynamoDB table to use for state locking."
  default     = "sostene-amalitech-remote-state-lock"
  type        = string
}
variable "default_aws_profile" {
  description = "The default AWS profile to use for authentication."
  default     = "sostene.amalitech"
  type        = string
}
variable "my_ip_address_with_cidr" {
  description = "Your public IP address with CIDR notation."
  type        = string
  default     = "0.0.0.0/0" # Replace with your actual IP address in CIDR notation
}
variable "ami" {
  description = "The AMI ID to use for the EC2 instance."
  type        = string
  default     = "resolve:ssm:/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
}
variable "instance_type" {
  description = "The type of instance to use for the EC2 instance."
  type        = string
  default     = "t3.micro"
}
variable "tag_name_prefix" {
  description = "The name tag to assign to the EC2 instance."
  type        = string
  default     = "sostene-iac-lab"
}
variable "owner" {
  description = "Owner tag applied to resources."
  type        = string
  default     = "Sostene"
}
variable "public_key_path" {
  description = "Path to the SSH public key file to import into AWS as the EC2 key pair. Generate it locally first (see README) - Terraform does not create the key pair."
  type        = string
  default     = "~/.ssh/iac-lab-key.pub"
}