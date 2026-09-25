#!/bin/zsh
# Private Subnet route table associations without nat gateway
VPC_ID="$(./get-vpc-id.sh)"
aws ec2 create-route-table --vpc-id "$VPC_ID" --tag-specifications 'ResourceType=route-table,Tags=[{Key=Name,Value=patientping-private-rt}]'
RT_ID="$(aws ec2 describe-route-tables --filters Name=tag:Name,Values=patientping-private-rt --query 'RouteTables[0].RouteTableId' --output text)"
SUBNET_IDS="$(aws ec2 describe-subnets --filters Name=tag:Name,Values=patientping-private-a,patientping-private-b --query 'Subnets[*].SubnetId' --output text)"
for SUBNET_ID in ${=SUBNET_IDS}; do
    aws ec2 associate-route-table --route-table-id "$RT_ID" --subnet-id "$SUBNET_ID"
done
