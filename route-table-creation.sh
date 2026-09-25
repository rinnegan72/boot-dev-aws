#!/bin/zsh
VPC_ID="$(./get-vpc-id.sh)"
# Create a route table
aws ec2 create-route-table --vpc-id "$VPC_ID" --tag-specifications 'ResourceType=route-table,Tags=[{Key=Name,Value=patientping-public-rt}]'
# Getting Route table ID
RT_ID="$(aws ec2 describe-route-tables --filters Name=tag:Name,Values=patientping-public-rt --query 'RouteTables[0].RouteTableId' --output text)"
# Associate the route table with a subnet (run once per public subnet)
# Subnet IDs for patientping-public-a and patientping-public-b with a vpc ID filter
SUBNET_IDS="$(aws ec2 describe-subnets --filters Name=tag:Name,Values=patientping-public-a,patientping-public-b --query 'Subnets[*].SubnetId' --output text)"
for SUBNET_ID in ${=SUBNET_IDS}; do
    aws ec2 associate-route-table --route-table-id "$RT_ID" --subnet-id "$SUBNET_ID"
done
# Get IGW id
IGW_ID="$(aws ec2 describe-internet-gateways --filters Name=tag:Name,Values=patientping-igw --query 'InternetGateways[0].InternetGatewayId' --output text)"
# Add a route to the route table
aws ec2 create-route --route-table-id "$RT_ID" --destination-cidr-block 0.0.0.0/0 --gateway-id "$IGW_ID"