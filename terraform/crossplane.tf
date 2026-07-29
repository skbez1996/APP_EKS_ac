locals {
  oidc_issuer = replace(module.eks.cluster_oidc_issuer_url, "https://", "")
}

# IAM role for Crossplane AWS provider (used via IRSA)
resource "aws_iam_role" "crossplane" {
  name = "${var.cluster_name}-crossplane"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Federated = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/${local.oidc_issuer}"
      }
      Action = "sts:AssumeRoleWithWebIdentity"
      Condition = {
        StringLike = {
          "${local.oidc_issuer}:sub" = "system:serviceaccount:upbound-system:*"
        }
      }
    }]
  })
}

data "aws_caller_identity" "current" {}

# S3 full access for Crossplane to manage S3 buckets
resource "aws_iam_role_policy_attachment" "crossplane_s3" {
  role       = aws_iam_role.crossplane.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

output "crossplane_role_arn" {
  value       = aws_iam_role.crossplane.arn
  description = "IAM role ARN for Crossplane AWS provider"
}
