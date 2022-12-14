# 👾 terraform or gcloud

Create a user-managed notebooks instance on GCP in one of 2 ways:

# Way 1 - using Terraform
In Cloud Shell, execute the following commands (replace MY-PROJECT-NAME):
```bash
mkdir tf
cd tf
nano main.tf  # then paste the file content
terraform init
terraform apply -var project=MY-PROJECT-ID
```

# Way 2 - using gcloud
In Cloud Shell, execute the following command:
```bash
bash create_notebooh.sh
```

# Reference
[Medium article - set up Vertex AI Workbench with Terraform](https://nakamasato.medium.com/set-up-vertex-ai-workbench-with-access-to-bigquery-and-gcs-using-terraform-3844e7cb65bb)  
[Terraform resource](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/notebooks_instance)  
[Terraform on GCP - all docs](https://cloud.google.com/docs/terraform)  
[Terraform on GCP - example](https://cloud.google.com/docs/terraform/get-started-with-terraform)
