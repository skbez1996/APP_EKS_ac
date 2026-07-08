output "tf_state_bucket" {
  value       = aws_s3_bucket.tf_state.bucket
  description = "S3 bucket name for Terraform state — add this as TF_STATE_BUCKET secret in GitHub"
}
