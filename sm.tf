resource "aws_secretsmanager_secret" "snowflake_secret" {
  description             = "Snowflake credentials for latesflow"
  kms_key_id              = data.aws_kms_key.sm.id
  name                    = "ca-cng-snowflake-ds-latesflow"
  recovery_window_in_days = 0
  policy = templatefile("${path.module}/templates/snowflake_secrets_manager.json.tpl", {
    account_id       = var.aws_account_id
  })

  tags = merge(
    tomap({"Name" = "ca-cng-snowflake-ds-latesflow"}),
    tomap({"classification" = "confidential"})
  )
}

resource "random_string" "snowflake_secret_password" {
  length  = 32
  special = false
}

resource "aws_secretsmanager_secret_version" "snowflake_version" {
  secret_id     = aws_secretsmanager_secret.snowflake_secret.id
  secret_string = <<EOF
{
  "SF_ACCOUNT": "vu66182.eu-central-1",
  "SF_HOST":    "vu66182.eu-central-1.snowflakecomputing.com",
  "SF_DB":      "CYDEV_DB",
  "SF_WH":      "CYDEV_YDE",
  "SF_WHUTIL":  "CYDEV_YDE_UTIL",
  "SF_SCHEMA":  "YIELD",
  "SF_USER":    "CYDEV_YDE_USER",
  "SF_PWD":     "CHANGE-ME-LATER"
}
EOF
}
