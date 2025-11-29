# Ways to Store & Use Secrets in Terraform

This document covers two areas:

1. How Terraform authenticates to AWS
2. How Terraform receives secret variables

---

## 1. How Terraform Authenticates to AWS

### A. Hardcoded credentials (NOT recommended)

```hcl
provider "aws" {
  access_key = "xxx"
  secret_key = "yyy"
}
```

### B. Shared credentials file

```hcl
provider "aws" {
  shared_credentials_file = "~/.aws/credentials"
  profile                 = "dev"
}
```

### C. Environment variables

Linux/macOS:

```bash
export AWS_ACCESS_KEY_ID="xxx"
export AWS_SECRET_ACCESS_KEY="yyy"
export AWS_SESSION_TOKEN="zzz"   # optional, for MFA/STS
```

Windows (PowerShell):

```powershell
setx AWS_ACCESS_KEY_ID "xxx"
setx AWS_SECRET_ACCESS_KEY "yyy"
setx AWS_SESSION_TOKEN "zzz"
```

### D. AWS CLI config (implicit)

Works automatically if you run:

```bash
aws configure
```

### E. IAM Role (EC2, ECS, Lambda) — Recommended

Terraform automatically uses the instance profile without embedded credentials.

### F. AWS SSO / IAM Identity Center

```hcl
provider "aws" {
  profile = "my-sso-profile"
}
```

### G. Web Identity / IRSA (EKS pods)

Terraform authenticates using IAM roles for service accounts (IRSA).

### H. Tools (aws-vault, chamber, sops)

Use these to manage credentials and secrets securely.

---

## 2. How Terraform Receives Input Variables (Secrets)

### A. Environment variables (`TF_VAR_*`)

Linux/macOS:

```bash
export TF_VAR_db_username="user"
export TF_VAR_db_password="pass"
```

Windows (PowerShell):

```powershell
setx TF_VAR_db_username "user"
setx TF_VAR_db_password "pass"
```

### B. `.tfvars` file (do NOT commit to Git)

`secret.tfvars`:

```hcl
db_username = "user"
db_password = "pass"
```

Usage:

```bash
terraform apply -var-file="secret.tfvars"
```

### C. CLI flags

```bash
terraform apply -var="db_password=pass123"
```

### D. AWS Secrets Manager (recommended)

Fetch secret in Terraform and decode JSON:

```hcl
data "aws_secretsmanager_secret" "db" {
  name = "myapp/db_credentials"
}

data "aws_secretsmanager_secret_version" "db" {
  secret_id = data.aws_secretsmanager_secret.db.id
}

locals {
  db_secret = jsondecode(data.aws_secretsmanager_secret_version.db.secret_string)
}
```

Access values:

```hcl
local.db_secret["username"]
local.db_secret["password"]
```

### E. SOPS-encrypted tfvars

Encrypt secrets with sops:

```bash
sops -e secret.tfvars > secret.enc.tfvars
```

### F. Terraform Cloud / Enterprise secure variables

Store sensitive variables in the workspace variable set.

---

## Summary — Best Practices

- Prefer IAM roles for EC2/ECS/Lambda and IRSA for EKS pods.
- Use AWS SSO (IAM Identity Center) where applicable.
- Keep secrets out of VCS (use `.tfvars`, SOPS, or remote secret stores).
- Use Terraform Cloud/Enterprise secure variable storage for shared state.

---

# Using AWS Secrets Manager with Terraform — Practical Guide

## Step 1 — Create a Secret in AWS Secrets Manager

Example secret (JSON):

```json
{
  "username": "admin",
  "password": "P@ssw0rd123"
}
```

Secret name example: `myapp/db_credentials`

## Step 2 — Configure Terraform provider

```hcl
provider "aws" {
  region = "us-east-1"
}
```

## Step 3 — Fetch the secret using Terraform

```hcl
data "aws_secretsmanager_secret" "db" {
  name = "myapp/db_credentials"
}

data "aws_secretsmanager_secret_version" "db" {
  secret_id = data.aws_secretsmanager_secret.db.id
}

locals {
  db_secret = jsondecode(data.aws_secretsmanager_secret_version.db.secret_string)
}
```

## Step 4 — Use the secret in resources

Example for an RDS instance:

```hcl
resource "aws_db_instance" "mydb" {
  identifier       = "mydb"
  engine           = "mysql"
  instance_class   = "db.t3.micro"
  username         = local.db_secret["username"]
  password         = local.db_secret["password"]
  allocated_storage = 20
}
```

## Step 5 — Mark outputs as sensitive

```hcl
output "db_username" {
  value = local.db_secret["username"]
}

output "db_password" {
  value     = local.db_secret["password"]
  sensitive = true
}
```

## Security note

Terraform will store retrieved secrets in the state file (terraform.tfstate). Mitigations:

- Use a secure backend (S3 with encryption + DynamoDB for locking, or Terraform Cloud).
- Enable KMS encryption for backend state.
- Restrict IAM access to state.
- Mark sensitive outputs with `sensitive = true`.

---

## Full Working Example (copy/paste)

```hcl
provider "aws" {
  region = "us-east-1"
}

data "aws_secretsmanager_secret" "db" {
  name = "myapp/db_credentials"
}

data "aws_secretsmanager_secret_version" "db" {
  secret_id = data.aws_secretsmanager_secret.db.id
}

locals {
  db_secret = jsondecode(data.aws_secretsmanager_secret_version.db.secret_string)
}

resource "aws_db_instance" "mydb" {
  identifier       = "mydb"
  engine           = "mysql"
  instance_class   = "db.t3.micro"
  username         = local.db_secret["username"]
  password         = local.db_secret["password"]
  allocated_storage = 20
}

output "db_username" {
  value = local.db_secret["username"]
}

output "db_password" {
  value     = local.db_secret["password"]
  sensitive = true
}
```
