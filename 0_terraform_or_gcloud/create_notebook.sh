# Environment variables
REGION=europe-west1
ZONE=europe-west1-b
PROJECT_ID=$(gcloud config list --format 'value(core.project)')
SERVICE_ACCOUNT=workbench-default  # name of the service account to be created

gcloud config set project $PROJECT_ID

# Enable APIs
gcloud services enable aiplatform.googleapis.com
gcloud services enable notebooks.googleapis.com
gcloud services enable bigquery.googleapis.com

# Create VPC network
gcloud compute networks create default  # network named 'default'

# Create router (for the NAT gateway)
gcloud compute routers create my-router \
    --network=default \
    --region=$REGION

# Create NAT gateway
gcloud compute routers nats create my-router-nat \
    --router=my-router \
    --auto-allocate-nat-external-ips \
    --nat-all-subnet-ip-ranges \
    --region=$REGION

# Create a service account and give it necessary permissions
gcloud iam service-accounts create $SERVICE_ACCOUNT \
    --display-name="Default service account for Vertex AI Workbench"

# Permissions to Cloud Storage
gcloud projects add-iam-policy-binding $PROJECT_ID \
    --member="serviceAccount:$SERVICE_ACCOUNT@$PROJECT_ID.iam.gserviceaccount.com" \
    --role="roles/storage.admin"

# Permissions to Vertex AI
gcloud projects add-iam-policy-binding $PROJECT_ID \
    --member="serviceAccount:$SERVICE_ACCOUNT@$PROJECT_ID.iam.gserviceaccount.com" \
    --role="roles/aiplatform.admin"

# Permissions to BigQuery
gcloud projects add-iam-policy-binding $PROJECT_ID \
    --member="serviceAccount:$SERVICE_ACCOUNT@$PROJECT_ID.iam.gserviceaccount.com" \
    --role="roles/bigquery.admin"

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

# Give compute service account admin permissions for Vertex AI
# (because Vertex Pipelines by default are run by the compute service account)
gcloud projects describe $PROJECT_ID > project-info.txt
PROJECT_NUM=$(cat project-info.txt | sed -nre 's:.*projectNumber\: (.*):\1:p')
COMPUTE_SERVICE_ACCOUNT="${PROJECT_NUM//\'/}-compute@developer.gserviceaccount.com"
gcloud projects add-iam-policy-binding $PROJECT_ID \
    --member="serviceAccount:$COMPUTE_SERVICE_ACCOUNT" \
    --role="roles/aiplatform.admin"
rm project-info.txt
