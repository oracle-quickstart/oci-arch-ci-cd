## Copyright © 2021, Oracle and/or its affiliates. 
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

variable "tenancy_ocid" {}
variable "user_ocid" {}
variable "private_key_path" {}
variable "fingerprint" {}
variable "compartment_ocid" {}
variable "region" {}


variable "release" {
  description = "Reference Architecture Release (OCI Architecture Center)"
  default     = "1.0"
}

variable "vcn_cidr" {
  default = "192.168.0.0/16"
}

variable "nodepool_subnet_cidr" {
  default = "192.168.1.0/24"
}

variable "lb_subnet_cidr" {
  default = "192.168.2.0/24"
}

variable "api_endpoint_subnet_cidr" {
  default = "192.168.3.0/24"
}

variable "jenkins_subnet_cidr" {
  default = "192.168.4.0/24"
}

variable "jenkins_http_port" {
  default = 8080
}

variable "jenkins_jnlp_port" {
  default = 49187
}

variable "oke_cluster_name" {
  default = "OKECluster4CICD"
}

variable "oke_node_shape" {
  default = "VM.Standard.E3.Flex"
}

variable "oke_node_ocpus" {
  default = 1
}

variable "oke_node_memory" {
  default = 4
}

variable "oke_node_count" {
  default = 3
}

variable "oke_k8s_version" {
  default = "v1.20.11"
}

variable "availablity_domain_name" {
  default = ""
}
variable "availablity_domain_number" {
  default = 0
}

variable "ssh_public_key" {
  default = ""
}
variable "ssh_private_key" {
  default = ""
}

variable "jenkins_password" {
  default = "Admin123"
}
variable "jenkins_version" {
  default = "2.277.4"
}

variable "jenkins_instance_shape" {
  description = "Instance Shape"
  default     = "VM.Standard.E3.Flex"
}

variable "plugins" {
  type        = list(string)
  description = "A list of Jenkins plugins to install, use short names. "
  default     = ["git", "ssh-slaves", "oracle-cloud-infrastructure-compute", "blueocean", "blueocean-github-pipeline"]
}

variable "instance_user" {
  default = "opc"
}

variable "instance_os" {
  description = "Operating system for compute instances"
  default     = "Oracle Linux"
}

variable "linux_os_version" {
  description = "Operating system version for all Linux instances"
  default     = "7.9"
}

variable "flex_shape_ocpus" {
  description = "Number of Flex shape OCPUs"
  default     = "1"
}

variable "flex_shape_memory" {
  description = "Amount of Flex shape Memory in GB"
  default     = "16"
}
