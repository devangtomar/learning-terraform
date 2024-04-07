```bash
cd modules
git init
git add .
git commit -m "Initial commit of modules repo"
git remote add origin "(URL OF REMOTE GIT REPOSITORY)"
git push origin main
git tag -a "v0.0.1" -m "First release of webserver-cluster module"
$ git push --follow-tags
```

Fetching part inside terraform code..

```terraform
module "webserver_cluster" {
  source                 = "github.com/foo/modules//services/webserver-cluster?ref=v0.0.1"
  cluster_name           = "webservers-stage"
  db_remote_state_bucket = "(YOUR_BUCKET_NAME)"
  db_remote_state_key    = "stage/data-stores/mysql/terraform.tfstate"
  instance_type          = "t2.micro"
  min_size               = 2
  max_size               = 2
}
```
