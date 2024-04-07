## Terraform commands list..

- `terraform init`
- `terraform fmt`
- `terraform validate`
- `terraform plan`
- `terraform apply --auto-approve`

## Later need to learn..

- `terraform state`
- `terraform import`
- `terraform init -backend-config=backend.hcl`

## Terraform workspace ~ We use workspaces for state file isolation for different env : qa, dev, stage and prod

For creating a workspace : `terraform workspace new prod`
For listing a workspace : `terraform workspace list`
For selecting a workspace : `terraform workspace select prod`

To put all your partial configurations together, run terraform init with the -backend-config argument : `terraform init -backend-config=backend.hcl`
