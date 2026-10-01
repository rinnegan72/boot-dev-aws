# Configure the AWS provider
provider "aws" {
  region = "us-east-1"
  profile = "floci"
}


resource "aws_iam_user" "bootdev-user" {
  name = "bootdev-user"
  path = "/"

  tags = {
    tag-key = "bootdev-user"
  }
}

resource "aws_iam_user_policy_attachment" "test-attach" {
  user       = aws_iam_user.bootdev-user.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}
