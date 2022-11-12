variable "project" {
  type = string
  description = "Google Cloud Project ID"
}

# Create VPN network and subnetwork
resource "google_compute_network" "net" {
  name = "my-vpc-network"
  auto_create_subnetworks = false
  mtu = 1460
}

resource "google_compute_subnetwork" "subnet" {
  name = "my-subnet"
  ip_cidr_range = "10.0.1.0/24"
  region =  "europe-west1"
  network = google_compute_network.net.id
}

# Create Cloud NAT and a router
resource "google_compute_router" "router" {
  name = "my-router"
  region = google_compute_subnetwork.subnet.region
  network = google_compute_network.net.id
}

resource "google_compute_router_nat" "nat" {
  name = "my-router-nat"
  router = google_compute_router.router.name
  region = google_compute_router.router.region
  nat_ip_allocate_option = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
}

# Create a service account and give it necessary permissions
resource "google_service_account" "workbench-default" {
  account_id = "workbench-default"
  display_name = "Default service account for Vertex AI Workbench"
}

resource "google_project_iam_binding" "workbench-default-storage-object-admin" {
  project = var.project
  role = "roles/storage.admin"
  members = ["serviceAccount:${google_service_account.workbench-default.email}"]
}

resource "google_project_iam_binding" "workbench-default-aiplatform-user" {
  project = var.project
  role = "roles/aiplatform.user"
  members = ["serviceAccount:${google_service_account.workbench-default.email}"]
}


# A weird thing I added because of an error:
# "you do not have permission to act as service_account ..."
resource "google_project_iam_binding" "workbench-default-iam-service-account-user" {
  project = var.project
  role = "roles/iam.serviceAccountUser"
  members = ["serviceAccount:${google_service_account.workbench-default.email}"]
}

# Create the notebook
resource "google_notebooks_instance" "test-notebook" {
  name = "test-notebook"
  location = "europe-west1-b"
  machine_type = "n1-standard-1"

  vm_image {
    project = "deeplearning-platform-release"
    image_family = "common-cpu-notebooks"
  }

  service_account = google_service_account.workbench-default.email

  no_public_ip = true

  shielded_instance_config {
    enable_secure_boot = true
  }

  network = google_compute_network.net.id
  subnet = google_compute_subnetwork.subnet.id
}

# Enable Vertex AI API
resource "google_project_service" "aiplatform" {
  project = var.project
  service = "aiplatform.googleapis.com"
}
