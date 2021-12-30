resource "aws_iam_role" "sagemaker_role" {
  name = "terraform-sagemaker"
  path = "/"
  assume_role_policy = "${data.aws_iam_policy_document.assume_role.json}"
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    actions = [ "sts:AssumeRole" ]
    principals {
      type = "Service"
      identifiers = [ "sagemaker.amazonaws.com" ]
    }
  }
}

resource "aws_iam_policy" "sagemaker_role" {
  name = "terraform-sagemaker"
  description = "Allow Sagemaker to create model"
  policy = "${data.aws_iam_policy_document.sagemaker_policy.json}"
}

data "aws_iam_policy_document" "sagemaker_policy" {
  statement {
    effect = "Allow"
    actions = [
      "sagemaker:*"
    ]
    resources = [
      "*"
    ]
  }
  }
  

resource "aws_iam_role_policy_attachment" "sagemaker_attachment" {
  role = "${aws_iam_role.sagemaker_role.name}"
  policy_arn = "${aws_iam_policy.sagemaker_policy.arn}"
}