#!/bin/bash
# 
# Builds a Docker image and pushes to an AWS ECR repository
#
# Invoked by the terraform-aws-ecr-docker-image Terraform module.
#
# Usage:
#
# # Acquire an AWS session token
# $ ./push.sh . 123456789012.dkr.ecr.us-west-1.amazonaws.com/hello-world latest
#

set -e

source_path="$1"
repository_url="$2"
tag="${3:-latest}"

# splits string using '.' and picks 4th item
region="$(echo "$repository_url" | cut -d. -f4)"

# splits string using '/' and picks 2nd item
image_name="$(echo "$repository_url" | cut -d/ -f2)"

(cd "$source_path" && docker build -t "$image_name" .)

# get token
aws ecr get-login-password --region "$region" | docker login --username AWS --password-stdin "$repository_url"

# tag image
docker tag "$image_name" "$repository_url":"$tag"

# push image
docker push "$repository_url":"$tag"