// Configure the provider
provider "google" {
	credentials = "${file("${var.credentials_file}")}"
	project = "${var.project_name}"
	region = "${var.vpc_region}"
}

// Create the VPC
resource "google_compute_network" "gcp_vpc" {
	name = "${var.vpc_name}"
	description = "${var.vpc_description}"
	auto_create_subnetworks = "false"
}

// Create subntes
resource "google_compute_subnetwork" "gcp_subnet1" {
	name = "${var.subnet1_name}"
	description = "${var.subnet1_description}"
	ip_cidr_range = "${var.subnet1_cidr}"
	network = "${var.vpc_name}"
	region = "${var.vpc_region}"
	depends_on = ["google_compute_network.gcp_vpc"]
}

// Setup VPC firewall
resource "google_compute_firewall" "gcp_vpc_firewall" {
	name = "${var.vpc_firewall_name}"
	description = "${var.vpc_firewall_description}"
	network = "${google_compute_network.gcp_vpc.name}"

	allow {
		protocol = "icmp"
	}

	allow {
		protocol = "tcp"
		ports = ["22"]
	}

	source_ranges = ["0.0.0.0/0"]
}


