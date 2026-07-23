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
variable "owner" {
  description = "Owner tag applied to resources."
  type        = string
  default     = "Sostene"
}