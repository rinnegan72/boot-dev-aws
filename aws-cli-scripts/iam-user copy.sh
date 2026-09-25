#!/bin/zsh
# Creating IAM user `sriram`
aws iam create-user --user-name sriram
# Attaching the admin policy
aws iam attach-user-policy --user-name sriram --policy-arn arn:aws:iam::aws:policy/AdministratorAccess
# Creating access key for IAM user
aws iam create-access-key --user-name sriram
# configure the profile for floci
aws configure --profile floci
