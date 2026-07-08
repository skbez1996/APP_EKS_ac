variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "tf_state_bucket" {
  type        = string
  description = "Name of the S3 bucket to store Terraform state"
}
