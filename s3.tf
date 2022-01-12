resource "aws_s3_bucket" "b" {
  bucket = "ca-cng-dev-datascience-latesflow"
  acl    = "private"

  tags = {
    Name        = "ca-cng-dev-datascience-latesflow"
    Environment = "dev"
  }
}
