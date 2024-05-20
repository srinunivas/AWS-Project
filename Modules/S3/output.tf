output "s3_bucket_id" {
  description = "Name of the bucket"
  value       = aws_s3_bucket.bucket.id
}

output "s3_bucket_arn" {
  description = "Arn of the bucket"
  value       = aws_s3_bucket.bucket.arn
}