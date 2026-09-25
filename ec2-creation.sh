#!/bin/zsh
aws ec2 create-security-group --group-name patientping-empty --description "Placeholder security group for PatientPing server" --vpc-id vpc-b77aa51d --region us-east-1 --profile floci
aws ec2 run-instances --image-id "ami-0abcdef1234567891" --instance-type t3.micro  --key-name patientping-key --subnet-id subnet-a7be0fad --security-group-ids sg-7b5f71c1cb9dceb17 --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=patientping-web}]' --profile floci
