resource "random_id" "s3_suffix" {


  byte_length = 4
}
locals {
  computed_lambda_source_bucket_name = "lambdasource.${random_id.s3_suffix.hex}"
}
resource "aws_s3_bucket" "lambda_source_bucket" {
  bucket = local.computed_lambda_source_bucket_name

  tags = local.common_tags
}
output "s3_bucket" {
    value = aws_s3_bucket.lambda_source_bucket.bucket
  
}