output "remote_state_bucket" {  
    value = aws_s3_bucket.remote_state.bucket
}
output "remote_state_bucket_arn" {  
    value = aws_s3_bucket.remote_state.arn
}
output "remote_domain_name" {  
    value = aws_s3_bucket.remote_state.bucket_domain_name
}

output "remote_state_lock_table_name" {  
    value = aws_dynamodb_table.remote_state_lock.name
}