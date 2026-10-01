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

resource "aws_iam_access_key" "bootdev-user" {
  user = aws_iam_user.bootdev-user.name
}

output "key_id" { value = aws_iam_access_key.bootdev-user.id }
output "key_secret" {
  value     = aws_iam_access_key.bootdev-user.secret
  sensitive = true
}
