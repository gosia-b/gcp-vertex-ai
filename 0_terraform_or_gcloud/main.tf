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

resource "google_notebooks_instance" "test-notebook" {
  name = "test-notebook"
  location = "europe-west1-b"
  machine_type = "n1-standard-1"

  vm_image {
    project = "deeplearning-platform-release"
    image_family = "common-cpu-notebooks"
  }

  no_public_ip = true

  shielded_instance_config {
    enable_secure_boot = true
  }

  network = google_compute_network.net.id
  subnet = google_compute_subnetwork.subnet.id
}
