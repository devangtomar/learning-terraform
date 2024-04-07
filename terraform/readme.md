# Terraform Commands List

Here's a list of basic Terraform commands you should familiarize yourself with:

- `terraform init` - Initializes a new or existing Terraform configuration.
- `terraform fmt` - Rewrites Terraform configuration files to a canonical format and style.
- `terraform validate` - Validates the Terraform configuration files in a directory.
- `terraform plan` - Creates an execution plan.
- `terraform apply --auto-approve` - Applies the changes required to reach the desired state of the configuration, and then automatically approves the execution.

## Isolation via File Layout

To achieve full isolation between environments, you need to do the following:

- Put the Terraform configuration files for each environment into a separate folder. For example, all of the configurations for the staging environment can be in a folder called `stage` and all the configurations for the production environment can be in a folder called `prod`.
- Configure a different backend for each environment, using different authentication mechanisms and access controls: e.g., each environment could live in a separate AWS account with a separate S3 bucket as a backend.

Diagram:

![File Layout](./file-layout.png)

At the top level, there are separate folders for each "environment." The exact environments differ for every project, but the typical ones are as follows:

- `stage` - An environment for pre-production workloads (i.e., testing)
- `prod` - An environment for production workloads (i.e., user-facing apps)
- `mgmt` - An environment for DevOps tooling (e.g., bastion host, CI server)
- `global` - A place to put resources that are used across all environments (e.g., S3, IAM)

Within each environment, there are separate folders for each "component." The components differ for every project, but here are the typical ones:

- `vpc` - The network topology for this environment.
- `services` - The apps or microservices to run in this environment, such as a Ruby on Rails frontend or a Scala backend. Each app could even live in its own folder to isolate it from all the other apps.
- `data-storage` - The data stores to run in this environment, such as MySQL or Redis. Each data store could even reside in its own folder to isolate it from all other data stores.

Within each component, there are the actual Terraform configuration files, which are organized according to the following naming convention:

- `variables.tf` - Input variables
- `outputs.tf` - Output variables
- `main.tf` - Resources and data sources

Here are just a few examples:

- `dependencies.tf` - It’s common to put all your data sources in a dependencies.tf file to make it easier to see what external things the code depends on.
- `providers.tf` - You may want to put your provider blocks into a providers.tf file so you can see, at a glance, what providers the code talks to and what authentication you’ll have to provide.
- `main-xxx.tf` - If the main.tf file is getting really long because it contains a large number of resources, you could break it down into smaller files that group the resources in some logical way: e.g., main-iam.tf could contain all the IAM resources, main-s3.tf could contain all the S3 resources, and so on. Using the main- prefix makes it easier to scan the list of files in a folder when they are organized alphabetically, as all the resources will be grouped together. It’s also worth noting that if you find yourself managing a very large number of resources and struggling to break them down across many files, that might be a sign that you should break your code into smaller modules instead.

## Terraform remote state Data source

For setting up the secrets.. use

```bash
export TF_VAR_db_username="(YOUR_DB_USERNAME)"
export TF_VAR_db_password="(YOUR_DB_PASSWORD)"

```

And here is how you do it on Windows systems:

```powershell
set TF_VAR_db_username="(YOUR_DB_USERNAME)"
set TF_VAR_db_password="(YOUR_DB_PASSWORD)"
```

All of the database’s output variables are stored in the state file, and you can read
them from the terraform_remote_state data source using an attribute reference of
the form:

```terraform
data.terraform_remote_state.<NAME>.outputs.<ATTRIBUTE>

```

For example, here is how you can update the User Data of the web server cluster
Instances to pull the database address and port out of the terraform_remote_state
data source and expose that information in the HTTP response:

```terraform
user_data = <<EOF
#!/bin/bash
echo "Hello, World" >> index.html
echo "${data.terraform_remote_state.db.outputs.address}" >> index.html
echo "${data.terraform_remote_state.db.outputs.port}" >> index.html
nohup busybox httpd -f -p ${var.server_port} &
EOF

```

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
