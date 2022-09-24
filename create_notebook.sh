# Enable APIs
gcloud services enable aiplatform.googleapis.com  # Vertex AI API
gcloud services enable notebooks.googleapis.com  # Notebooks API

# Create VPC network
gcloud compute networks create default  # network named 'default'

# Create router (for the NAT gateway)
gcloud compute routers create my-router \
    --network=default \
    --region=europe-west1

# Create NAT gateway
gcloud compute routers nats create my-nat-gateway \
    --router=my-router \
    --auto-allocate-nat-external-ips \
    --nat-all-subnet-ip-ranges \
    --region=europe-west1

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
    --zone=europe-west1-b \
    --no-address \
    --machine-type=n1-standard-4

gcloud notebooks instances register my-notebook \
    --location=europe-west1-b
