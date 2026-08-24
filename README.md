# Azure DevOps CI/CD to AWS Amazon Connect Environments

This repository contains Terraform for Amazon Connect in multi-region AWS Dev
and UAT environments. Azure Repos and Azure Pipelines run Terraform against AWS
across three regions.

## Environments

- Dev: `environments/dev`
- UAT: `environments/uat`

Each environment has its own Terraform root, variable values, backend state key,
and Azure DevOps approval environment. Both environments use the shared Connect
module in `modules/connect`.

The pipeline also selects one infrastructure module per run. Each selected
module uses its own Terraform state file in S3 using the environment, region,
and module order.

## Regions

- US: `us-east-1`
- Europe: `eu-central-1`
- APAC: `ap-southeast-1`

## Architecture

Each environment deploys one Amazon Connect module in each region. The shared
module creates:

- Amazon Connect instance
- Primary queue
- Agent security profile
- Primary routing profile
- Placeholder inbound contact flow

No VPC, subnet, NAT, route table, S3, Lambda, Lex, DynamoDB, CloudWatch,
CloudTrail, IAM, API Gateway, Secrets Manager, or Contact Lens modules are part
of this target.

The disposable EC2 test module can be selected separately for pipeline smoke
testing. It creates:

- One Ubuntu 22.04 EC2 instance for simple pipeline testing
- `t3.nano` instance type
- EC2 key pair name `default`

Create an EC2 key pair named `default` in each region before applying the EC2
test module. AWS will use the selected region's default VPC behavior for this
simple test instance.

## Backend

Terraform uses an S3 backend with native S3 state locking:

```hcl
terraform {
  backend "s3" {
    use_lockfile = true
  }
}
```

Create the backend bucket before running the pipeline. The Azure pipeline uses:

```text
bucket: company-aws-connect-terraform-state
dev key: terraform-state/dev/us-east-1/connect/terraform.tfstate
uat key: terraform-state/uat/us-east-1/connect/terraform.tfstate
region: us-east-1
encrypt: true
use_lockfile: true
```

The backend key pattern is:

```text
terraform-state/<environment>/<region>/<module>/terraform.tfstate
```

The same environment/region/module order is used for pipeline plan artifacts and
display names.

Examples:

```text
terraform-state/dev/us-east-1/connect/terraform.tfstate
terraform-state/uat/eu-central-1/connect/terraform.tfstate
terraform-state/dev/multi-region/connect/terraform.tfstate
```

## Local Terraform

From either environment root:

```bash
cd environments/dev
# or
cd environments/uat

terraform init -reconfigure \
  -backend-config="bucket=company-aws-connect-terraform-state" \
  -backend-config="key=terraform-state/dev/us-east-1/connect/terraform.tfstate" \
  -backend-config="region=us-east-1" \
  -backend-config="encrypt=true"

terraform fmt -check -recursive ../..
terraform validate
terraform plan
```

Use the matching backend key for the selected environment. For UAT, use:

```text
terraform-state/uat/us-east-1/connect/terraform.tfstate
```

To target one region:

```bash
terraform plan -target='module.connect_us_east_1[0]'
terraform plan -target='module.connect_eu_central_1[0]'
terraform plan -target='module.connect_ap_southeast_1[0]'
```

To activate only the Connect module in this state:

```bash
terraform plan -var='enabled_modules=["connect"]'
```

## Azure Pipeline Flow

The pipeline in `azure-pipelines.yml` supports these parameters:

- `targetEnvironment`: `dev` or `uat`
- `targetRegion`: `all`, `us-east-1`, `eu-central-1`, or `ap-southeast-1`
- `targetModule`: `connect` or `ec2`
- `terraformAction`: `plan` or `apply`

When more modules are added later, add the module name to:

- `targetModule` values in `azure-pipelines.yml`
- `enabled_modules` validation in each environment's `variables.tf`
- module gating locals and module blocks in each environment root
- the pipeline target mapping for region and module

The flow is:

```text
Code Commit -> Terraform Init -> Plan -> Approval -> Apply
```

The apply stage is gated through the Azure DevOps environment selected by
`targetEnvironment`. Configure the `dev` and `uat` Azure DevOps environments
with the review and approval checks your team needs.

Required Azure DevOps variables:

- `AWS_DEV_OIDC_ROLE_ARN`: AWS IAM role ARN assumed for Dev
- `AWS_UAT_OIDC_ROLE_ARN`: AWS IAM role ARN assumed for UAT

The pipeline uses Azure Pipelines OIDC and Terraform's AWS web identity
authentication. It does not require static AWS access keys.

The AWS IAM roles must trust the Azure DevOps OIDC issuer for this pipeline.
The pipeline requests the OIDC token from `System.OidcRequestUri`, writes it to a
temporary token file, and exports:

```text
AWS_ROLE_ARN
AWS_WEB_IDENTITY_TOKEN_FILE
AWS_ROLE_SESSION_NAME
```

Make sure the pipeline can access `System.AccessToken`, because it is used to
request the OIDC token from Azure DevOps.


backendKey: 'terraform-state/${{ parameters.targetEnvironment }}/${{ parameters.targetRegion }}/${{ parameters.targetModule }}/terraform.tfstate'
