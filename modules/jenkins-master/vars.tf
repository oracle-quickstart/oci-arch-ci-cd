## Copyright © 2020, Oracle and/or its affiliates. 
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

variable "tenancy_ocid" {}
variable "compartment_ocid" {}
variable "availability_domain" {}
variable "jenkins_version" {}
variable "jenkins_password" {}
variable "master_display_name" {}
variable "subnet_id" {}
variable "instance_shape" {}
variable "ssh_public_key" {}
variable "ssh_private_key" {}
variable "http_port" {}
variable "plugins" {}
variable "instance_user" {}
variable "instance_os" {}
variable "linux_os_version" {}

variable "flex_shape_ocpus" {}

variable "flex_shape_memory" {}