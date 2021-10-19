
# Terraform: host website/frontend on S3

Static Website hosted on an S3 bucket yaaaay :)

This technique can be used to host your frontend (Angular for example) on S3 bucket. No server headache :p

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