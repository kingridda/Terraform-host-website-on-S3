Static Website hosted on S3 bucket yaaaay :)

## Create the infrastructure
```
terraform init
terraform validate
terraform plan -out myplan.tfplan
terraform apply "myplan.tfplan"
```

## Destroy the infrastructure
```
terraform destroy
```