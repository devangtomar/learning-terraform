# Terraform Commands List

Here's a list of basic Terraform commands you should familiarize yourself with:

- `terraform init` - Initializes a new or existing Terraform configuration.
- `terraform fmt` - Rewrites Terraform configuration files to a canonical format and style.
- `terraform validate` - Validates the Terraform configuration files in a directory.
- `terraform plan` - Creates an execution plan.
- `terraform apply --auto-approve` - Applies the changes required to reach the desired state of the configuration, and then automatically approves the execution.

## Later Need to Learn

As you become more comfortable with Terraform, consider learning these advanced commands:

- `terraform state` - Advanced state management.
- `terraform import` - Import existing infrastructure into Terraform.
- `terraform init -backend-config=backend.hcl` - Initialize Terraform with specific backend configuration.

## Terraform Workspace

We use workspaces for state file isolation for different environments: `qa`, `dev`, `stage`, and `prod`.

- For creating a workspace: `terraform workspace new prod`
- For listing workspaces: `terraform workspace list`
- For selecting a workspace: `terraform workspace select prod`

### More on Terraform Workspace

Terraform workspaces can be a great way to quickly spin up and tear down different versions of your code, but they have a few drawbacks:

- The state files for all of your workspaces are stored in the same backend (e.g., the same S3 bucket). That means you use the same authentication and access controls for all the workspaces, which is one major reason workspaces are an unsuitable mechanism for isolating environments (e.g., isolating staging from production).
- Workspaces are not visible in the code or on the terminal unless you run `terraform workspace` commands. When browsing the code, a module that has been deployed in one workspace looks exactly the same as a module deployed in 10 workspaces. This makes maintenance more difficult because you don’t have a good picture of your infrastructure.
- Putting the two previous items together, the result is that workspaces can be fairly error-prone. The lack of visibility makes it easy to forget what workspace you’re in and accidentally deploy changes in the wrong one (e.g., accidentally running `terraform destroy` in a “production” workspace rather than a “staging” workspace), and because you must use the same authentication mechanism for all.

## Terraform Backend

For storing state (via S3 bucket or any files storage) and locking it (via DynamoDB).

To put all your partial configurations together, run `terraform init` with the `-backend-config` argument:

- `terraform init -backend-config=backend.hcl`
