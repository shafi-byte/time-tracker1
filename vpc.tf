resource "aws_vpc" "cng" {
  cidr_block           = "${var.cidr}"
  instance_tenancy     = "${var.instance_tenancy}"
    tags = merge(
    var.common_tags,
    tomap({"Name" = var.vpc_name})
  )

}