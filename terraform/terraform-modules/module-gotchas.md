# Terraform Path References

By default, Terraform interprets the path relative to the current working directory. This works if you're using the `templatefile` function in a Terraform configuration file that's in the same directory as where you're running `terraform apply`. However, this won't work when you're using `templatefile` in a module that's defined in a separate folder (a reusable module).

To solve this issue, you can use an expression known as a path reference, which is of the form `path.<TYPE>`. Terraform supports the following types of path references:

- `path.module`: Returns the filesystem path of the module where the expression is defined.
- `path.root`: Returns the filesystem path of the root module.
- `path.cwd`: Returns the filesystem path of the current working directory. In normal use of Terraform, this is the same as `path.root`, but some advanced uses of Terraform run it from a directory other than the root module directory, causing these paths to be different.

For the User Data script, you need a path relative to the module itself, so you should use `path.module` when calling the `templatefile` function in `modules/services/webserver-cluster/main.tf`:

```hcl
user_data = templatefile("${path.module}/user-data.sh", {
  server_port = var.server_port
  db_address = data.terraform_remote_state.db.outputs.address
  db_port = data.terraform_remote_state.db.outputs.port
})
```
