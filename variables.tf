## Copyright © 2020, Oracle and/or its affiliates. 
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

variable "tenancy_ocid" {}
variable "user_ocid" {}
variable "private_key_path" {}
variable "compartment_ocid" {}
variable "region" {}
variable "fingerprint" {}
variable "ssh_public_key" {}
variable "ssh_private_key" {}
variable "availability_domain" {
  default="3"
}
variable "jenkins_password" {
  default     = "Admin123"
}
variable "jenkins_version" {
#    default     = "2.204.2"
  default    = "2.249.1"
}
variable "master_display_name" {
   default     = "jenkins-instance"
}
variable "instance_shape" {
  description = "Instance Shape"
  default     = "VM.Standard2.1"
}
variable "http_port" {
  default     = 8080
}
variable "plugins" {  
  type        = list(string)
  description = "A list of Jenkins plugins to install, use short names. "
  default     = ["git", "ssh-slaves", "oracle-cloud-infrastructure-compute", "blueocean", "blueocean-github-pipeline"]
  }
variable "instance_user" {
  default="opc"
}
variable "instance_os" {
  description = "Operating system for compute instances"
  default     = "Oracle Linux"
}
variable "linux_os_version" {
  description = "Operating system version for all Linux instances"
  default     = "7.8"
}
