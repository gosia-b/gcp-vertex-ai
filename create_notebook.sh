# Environment variables
REGION=europe-west1
ZONE=europe-west1-b

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

# Create service account
gcloud iam service-accounts create sa-vertex \
    --display-name="Service account for testing Vertex AI" \
    --role="roles/storage.admin"  # https://cloud.google.com/storage/docs/access-control/iam-roles

# Create notebook

# In case of creating the notebook in the console - because of the organization policy, make sure to:
# - check "Turn on Secure Boot"
# - uncheck "Enable external IP address"

# Creating a notebook using a shielded VM (Secure Boot constraint):
# https://cloud.google.com/vertex-ai/docs/workbench/user-managed/shielded-vm

gcloud compute instances create my-notebook \
    --image-project=deeplearning-platform-release \
    --image-family=common-cpu-notebooks-debian-10 \
    --metadata="proxy-mode=service_account" \
    --scopes=https://www.googleapis.com/auth/cloud-platform \
    --shielded-secure-boot \
    --zone=$ZONE \
    --no-address \
    --machine-type=n1-standard-4

gcloud notebooks instances register my-notebook \
    --location=$ZONE
