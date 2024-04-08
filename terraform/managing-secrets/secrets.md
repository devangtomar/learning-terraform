## For storing secrets.

1. Hardcode the secrets (not recommended)
2. Use shared_file..

```terraform
provider "aws" {
  shared_credentials_file = "./file.txt"
}
```

3. Use environment variable

```bash
export AWS_ACCESS_KEY_ID = 'adfdsfsf'
export AWS_SECRET_ACCESS_KEY = 'dfsfdsf'
```

4. Use solutions like : AWS secrets manager, GCP secrets manager or Azure key vault


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
