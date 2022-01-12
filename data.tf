data "aws_kms_key" "sm" {
  key_id = "alias/ca_cng_datascience_latesflow_s3key"
}
