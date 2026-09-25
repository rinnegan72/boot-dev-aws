#!/bin/zsh
aws ec2 describe-vpcs --no-cli-pager --filters 'Name=tag:Name,Values=patientping' --query 'Vpcs[0].VpcId' --output text
