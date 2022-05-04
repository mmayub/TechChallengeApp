# Servian DevOps Tech Challenge - Tech Challenge App

TABLE OF CONTENTS:

1. [High level design diagram](#1-high-level-design-diagram)

2. [How to deploy](#4-how-to-deploy)

    - [Dependencies](#dependencies)
    - [AWS account authentication](#aws-account-authentication)
    - [Manually create an S3 bucket in your AWS account](#manually-create-an-s3-bucket-in-your-aws-account)
    - [Configure Terraform backend and variables](#configure-terraform-backend-and-variables)
    - [Run Terraform](#run-terraform)
    - [Run update on database](#run-update-on-database)
    - [Delete the stack](#delete-the-stack)

3. [GitHub Actions](#5-github-actions)

4. [Challenges](#6-challenges)

5. [Future recommendations](#7-future-recommendations)


## 1. High level design diagram

![techChallenge.drawio.png](techChallenge.drawio.png)

*The above diagram represents a high available solution (tasks and database deployed in multiple subnets). For demonstration and learning purposes, the implementation is fixed to deploy a single replica for the database*

---

## 4. How to deploy

### Dependencies

- [Docker](https://www.docker.com/)
- [Terraform 1.1.2](https://www.terraform.io/)
- [AWS CLI](https://aws.amazon.com/cli/)

### AWS account authentication

To run below commands, you will need to make sure to be authenticated to an AWS account.
That can be done either exporting an AWS IAM User key/secret or by using roles if you have that setup.

[Configure AWS cli credentials](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-files.html#cli-configure-files-where)

### Manually create an S3 bucket in your AWS account
No extra configuration is needed, ensure AWS credentials give access to the S3 bucket.

[Create a S3 Bucket](https://docs.aws.amazon.com/AmazonS3/latest/userguide/creating-bucket.html)

### Configure Terraform backend and variables

Before running the Terraform commands, you will need to make sure that the following variables:
	-> Go to terraform/main.tf
	-> update bucket in s3 with your bucket name 

	-> copy environments.tfvars.example file and create environments.tfvars
	-> replace values with your values

	-> copy secrets.tfvars.example file and create secrets.tfvars
	-> replace with your secrets
	NOTE: don't check secrets.tfars file

### Run Terraform

With all variables configured, you can run the following Terraform scripts from terraform directory:

`terraform init`
	This will configure the backend in the config.tf file and download the cloud provider being used, in this case AWS.
`. tplan.sh`
	This will show you which AWS resources will be deployed and save the result in a file called `terraform.plan`.

`. tapply.sh`
	    This will apply the `terraform.plan` file created in the previous step to deploy resources to your AWS account and create the `terraform.tfstate` file in your previously manually created S3 bucket.
	    After the creation, it will return some outputs with the information of the resources created in the cloud. Make sure use `alb_dns_name` in the browser to check the application or if you have dns configured use `app_dns_name`.

### Delete the stack

Once you have tested this stack, it is recommended to delete all resources created on your AWS account to avoid any extra costs. Databases running 24/7 can get quite expensive.

`. tdelete.sh`
	This will destroy all the resources earlier deployed by terraform

---

### Run update on database

To populate the application's database, a script will perform updates and migrations on the application's database.

The script runs a standalone ECS task to update/migrate the application database. At this stage, it is important to make sure that Terraform (v1.1.2) and the AWS cli are installed on your local machine as the script is not using the 3Musketeers pattern. Unfortunately, I couldn't find a way to get the terraform variable values using containers.


---

## 5. GitHub Actions

There is a provided example of a Github Actions Workflow under [/.github/workflows/terraform-infra.yml](/.github/workflows/terraform-infra.yml) file.

The workflow example will run if any changes to `/infra/**` files are commited and below rules are met:

- On pull requests to master
    - make init
    - make plan
- On push to master (merge)
    - make init
    - make plan
    - make apply

You can either check my own repository to see some pipeline runs or fork this repo and setup from your side.

https://github.com/vanessadenardin/servian-tech-challenge/actions

Once you fork this repository, you will need to go to Settings > Secrets and create a secret variable for each of the below variables:

```
VPC_ID
POSTGRESQL_PASSWORD
DOMAIN_NAME
CERTIFICATE_ARN
```

Those variables are being reference by the workflow as per below:

```yaml
- name: Terraform Plan
id: plan
env:
    TF_VAR_vpc_id: ${{ secrets.VPC_ID }}
    TF_VAR_postgresql_password: ${{ secrets.POSTGRESQL_PASSWORD }}
    TF_VAR_domain_name: ${{ secrets.DOMAIN_NAME }}
    TF_VAR_certificate_arn: ${{ secrets.CERTIFICATE_ARN }}
    TF_VAR_production: false
run: make plan
```

---

## 6. Challenges
---

## 7. Future Recommendations

- Resource creation has been tested being created in default AWS VPC/subnets, hence having public access. I have no experience creating VPC/subnets/route tables/etc from scratch and it's still confusing for me. However, I chose to ensure that security groups are only open for what is needed.

- Move application database from AWS Aurora provisioned to serverless to save money.

- Fix update_db script to use the 3Musketeers pattern.

[Access old README](/readme_old.md)


## High level overview of deployment

The deployment will create 2 types of subnets (private and public) across all 3 availability zones for the ap-southeast-2 region in AWS.\
3 public subnets for the load balancer and internet access for the NAT gateway and 3 private subnets to run the virtual machines and postgres database.\
The virtual machines are scaled in using an auto scale group and the [install.sh](terraform/install.sh) script runs the initial setup of the server when instances are spin up.

## Prerequisites to deploy

- AWS account
- AWS cli credentials are configured via shared credentials file (or any other authentication method) and terraform has access to use credentials
- Latest version of Terraform installed (tested on terraform 1.0.3)

## Deployment steps

1. Move to the `/terraform` dirctory of the repo
2. Run `terraform init` then `terraform apply`

Around 5 minutes after the terraform build is done, the app should be accessible via the load balancer (techchallenge-alb-XXXX.ap-southeast-2.elb.amazonaws.com)