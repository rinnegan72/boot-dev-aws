aws ec2 create-vpc \
  --cidr-block '10.0.0.0/22' \
  --tag-specifications "ResourceType=vpc,Tags=[{Key=Name,Value=patientping}]"