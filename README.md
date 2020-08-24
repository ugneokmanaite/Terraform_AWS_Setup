# Terraform

## Orchestration tool
- Creates the infrastructure, not only the specific machine but the networking, security, monitoring and all of the setup around the machine which creates a production envirment

In this project we have used Terraform to orchestrate a n-tier achitecture from AMIs of previously created instances

This allowed us to create the following:
1. VPC
2. Subnets - Public and Private
3. Internet Gateway
4. Security groups with inbound and outbound rules
5. Instances for both web abb and db

## For basic introduction & intro steps follow link below
[click here](https://github.com/ugneokmanaite/Terraform)


## Step 1: Create `main.tf` and `variables.tf` files 

[click here for main.tf file](https://github.com/ugneokmanaite/Terraform_AWS_Setup/blob/master/main.tf)

[click here for variables.tf file](https://github.com/ugneokmanaite/Terraform_AWS_Setup/blob/master/variables.tf)

## Step 2: Ensure that API keys (access and secret) are stored in your environment variables in your machine

## Step 3: Launch the following commands:
`terraform init`

`terraform plan`

`terraform apply`

## Step 4: Configure auto scaling groups on AWS

Follow the link [here](https://docs.aws.amazon.com/autoscaling/ec2/userguide/create-asg.html) for the documentation 


 
