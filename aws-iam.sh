#!/bin/zsh
# This script is to be run to configure the IAM user that bootdev expects
aws configure set aws_access_key_id "$(tofu output -raw key_id)" --profile floci --no-cli-pager
aws configure set aws_secret_access_key "$(tofu output -raw key_secret)" --profile floci --no-cli-pager
aws sts get-caller-identity --profile floci --no-cli-pager
