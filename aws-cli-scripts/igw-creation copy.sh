#!/bin/zsh
VPC_ID="$(./get-vpc-id.sh)"
# Create an internet gateway
aws ec2 create-internet-gateway --tag-specifications 'ResourceType=internet-gateway,Tags=[{Key=Name,Value=patientping-igw}]'
# Get IGW id
IGW_ID="$(aws ec2 describe-internet-gateways --filters Name=tag:Name,Values=patientping-igw --query 'InternetGateways[0].InternetGatewayId' --output text)"
# Attach the IGW to a VPC
aws ec2 attach-internet-gateway --internet-gateway-id "$IGW_ID" --vpc-id "$VPC_ID"