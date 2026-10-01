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

resource "aws_vpc" "patientping" {
  cidr_block       = "10.0.0.0/22"

  tags = {
    Name = "patientping"
  }
}

output "vpc_id" {
  value = aws_vpc.patientping.id
}

resource "aws_subnet" "patientping-private-a" {
  vpc_id     = aws_vpc.patientping.id
  cidr_block = "10.0.0.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name = "patientping-private-a"
  }
}


resource "aws_subnet" "patientping-private-b" {
  vpc_id     = aws_vpc.patientping.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1b"
  tags = {
    Name = "patientping-private-b"
  }
}


resource "aws_subnet" "patientping-public-a" {
  vpc_id     = aws_vpc.patientping.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name = "patientping-public-a"
  }
}


resource "aws_subnet" "patientping-public-b" {
  vpc_id     = aws_vpc.patientping.id
  cidr_block = "10.0.3.0/24"
  availability_zone = "us-east-1b"
  tags = {
    Name = "patientping-public-b"
  }
}


resource "aws_internet_gateway" "patientping-igw" {
  vpc_id = aws_vpc.patientping.id

  tags = {
    Name = "patientping-igw"
  }
}
