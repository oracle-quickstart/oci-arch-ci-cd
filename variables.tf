variable "tenancy_ocid" {}
variable "user_ocid" {}
variable "private_key_path" {}
variable "compartment_ocid" {}
variable "region" {}
variable "fingerprint" {}
variable "ssh_public_key" {}
variable "ssh_authorized_private_key" {}
variable "availability_domain" {
  default="3"
}
variable "jenkins_password" {
  default     = "Admin123"
}
variable "jenkins_version" {
    default     = "2.204.2"
}
variable "master_display_name" {
   default     = "Jenkins-Master-Node"
}
variable "image_ocid" {}
variable "instance_shape" {}
variable "http_port" {
  default     = 8080
}
variable "plugins" {  
  type        = "list"
  description = "A list of Jenkins plugins to install, use short names. "
  default     = ["git", "ssh-slaves", "oracle-cloud-infrastructure-compute", "blueocean", "blueocean-github-pipeline"]
  }
variable "instance_user" {
  default="opc"
}
