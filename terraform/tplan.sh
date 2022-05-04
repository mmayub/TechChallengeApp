# use this to dry run terraform - `terraform plan`
terraform plan -var-file="secret.tfvars" -var-file="environment.tfvars" -out="out.plan"
