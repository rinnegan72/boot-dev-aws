# Configure the AWS provider
provider "aws" {
  region  = "us-east-1"
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
  cidr_block = "10.0.0.0/22"

  tags = {
    Name = "patientping"
  }
}

output "vpc_id" {
  value = aws_vpc.patientping.id
}

resource "aws_subnet" "patientping-private-a" {
  vpc_id            = aws_vpc.patientping.id
  cidr_block        = "10.0.0.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name = "patientping-private-a"
  }
}


resource "aws_subnet" "patientping-private-b" {
  vpc_id            = aws_vpc.patientping.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1b"
  tags = {
    Name = "patientping-private-b"
  }
}


resource "aws_subnet" "patientping-public-a" {
  vpc_id            = aws_vpc.patientping.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name = "patientping-public-a"
  }
}


resource "aws_subnet" "patientping-public-b" {
  vpc_id            = aws_vpc.patientping.id
  cidr_block        = "10.0.3.0/24"
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


resource "aws_route_table" "patientping-public-subnet-route-table" {
  vpc_id = aws_vpc.patientping.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.patientping-igw.id
  }

  tags = {
    Name = "patientping-public-rt"
  }
}


resource "aws_route_table_association" "patientping-public-a-rt-association" {
  subnet_id      = aws_subnet.patientping-public-a.id
  route_table_id = aws_route_table.patientping-public-subnet-route-table.id
}
resource "aws_route_table_association" "patientping-public-b-rt-association" {
  subnet_id      = aws_subnet.patientping-public-b.id
  route_table_id = aws_route_table.patientping-public-subnet-route-table.id
}


resource "aws_route_table" "patientping-private-subnet-route-table" {
  vpc_id = aws_vpc.patientping.id

  tags = {
    Name = "patientping-private-rt"
  }
}

resource "aws_route_table_association" "patientping-private-a-rt-association" {
  subnet_id      = aws_subnet.patientping-private-a.id
  route_table_id = aws_route_table.patientping-private-subnet-route-table.id
}
resource "aws_route_table_association" "patientping-private-b-rt-association" {
  subnet_id      = aws_subnet.patientping-private-b.id
  route_table_id = aws_route_table.patientping-private-subnet-route-table.id
}


resource "aws_key_pair" "patientping-key" {
  key_name   = "patientping-key"
  public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILzPx8fUgaFFbwTzNxGhErwlUo9ksE1iU4vbwB9rCCl3 patentping-key"
}
