## Isolation via File Layout

To achieve full isolation between environments, you need to do the following:

- Put the Terraform configuration files for each environment into a separate folder. For example, all of the configurations for the staging environment can be in a folder called `stage` and all the configurations for the production environment can be in a folder called `prod`.
- Configure a different backend for each environment, using different authentication mechanisms and access controls: e.g., each environment could live in a separate AWS account with a separate S3 bucket as a backend.

Diagram:

![File Layout](../../file-layout.png)

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
