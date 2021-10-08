## Copyright © 2020, Oracle and/or its affiliates. 
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

############################################
# Jenkins Master Instance
############################################

module "vcn" {
  source = "./modules/vcn"
  tenancy_ocid          = var.tenancy_ocid
  compartment_ocid      = var.compartment_ocid
}

module "jenkins-master" {
  source                = "./modules/jenkins-master"
  tenancy_ocid          = var.tenancy_ocid
  availability_domain   = var.availability_domain
  compartment_ocid      = var.compartment_ocid
  master_display_name   = var.master_display_name
  instance_shape        = var.instance_shape
  flex_shape_ocpus      = var.flex_shape_ocpus
  flex_shape_memory     = var.flex_shape_memory
  instance_user         = var.instance_user
  subnet_id             = module.vcn.subnet1_ocid
  jenkins_version       = var.jenkins_version
  jenkins_password      = var.jenkins_password
  http_port             = var.http_port
  ssh_public_key        = var.ssh_public_key
  ssh_private_key       = var.ssh_private_key
  plugins               = var.plugins
  instance_os           = var.instance_os
  linux_os_version      = var.linux_os_version
}

module "k8s" {
  source                = "./modules/k8s"
  tenancy_ocid          = var.tenancy_ocid
  compartment_ocid      = var.compartment_ocid
  vcn                   = module.vcn.vcn_id
  clustersub1_id        = module.vcn.subnet1_ocid
  nodesub1_id           = module.vcn.subnet2_ocid
  ssh_public_key        = var.ssh_public_key
  availability_domain   = var.availability_domain
} 
