# IMPORTANT: this code finally didn't work - notebooks instance was "creating" endlessly.
# What might have helped:
# 1) Troubleshooting: click name of the notebook, then "Health" and follow the documentation for the "Unhealthy" part
# 2) Stop and resume the VM (in Compute Engine)

# Environment variables
REGION=europe-west1
ZONE=europe-west1-b
PROJECT_ID=cloud4us-gcp-i67w0t0rvc5d3ufap
SERVICE_ACCOUNT=sa-vertex  # name of the service account to be created

gcloud config set project $PROJECT_ID

# Enable APIs
gcloud services enable aiplatform.googleapis.com  # Vertex AI API
gcloud services enable notebooks.googleapis.com  # Notebooks API

# Create VPC network
gcloud compute networks create default  # network named 'default'

# Create router (for the NAT gateway)
gcloud compute routers create my-router \
    --network=default \
    --region=$REGION

# Create NAT gateway
gcloud compute routers nats create my-nat-gateway \
    --router=my-router \
    --auto-allocate-nat-external-ips \
    --nat-all-subnet-ip-ranges \
    --region=$REGION

# Create a service account
gcloud iam service-accounts create $SERVICE_ACCOUNT \
    --display-name="Service account for testing Vertex AI"

# Grant the service account an IAM role on the project
gcloud projects add-iam-policy-binding $PROJECT_ID \
    --member="serviceAccount:$SERVICE_ACCOUNT@$PROJECT_ID.iam.gserviceaccount.com" \
    --role="roles/storage.admin"  # https://cloud.google.com/storage/docs/access-control/iam-roles

# In case of creating the notebook in the console - because of the organization policy, make sure to:
# - check "Turn on Secure Boot"
# - uncheck "Enable external IP address"

# Creating a notebook using a shielded VM (Secure Boot constraint):
# https://cloud.google.com/vertex-ai/docs/workbench/user-managed/shielded-vm

gcloud compute instances create my-notebook \
    --service-account=$SERVICE_ACCOUNT@$PROJECT_ID.iam.gserviceaccount.com \
    --image-project=deeplearning-platform-release \
    --image-family=common-cpu-notebooks-debian-10 \
    --metadata="proxy-mode=service_account,enable-guest-attributes=TRUE" \
    --scopes=https://www.googleapis.com/auth/cloud-platform \
    --shielded-secure-boot \
    --zone=$ZONE \
    --no-address \
    --machine-type=n1-standard-4

gcloud notebooks instances register my-notebook \
    --location=$ZONE
