## Copyright © 2021, Oracle and/or its affiliates. 
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

module "jenkins" {
  source                       = "github.com/oracle-quickstart/oci-jenkins"
  compartment_ocid             = var.compartment_ocid
  jenkins_version              = var.jenkins_version
  jenkins_password             = var.jenkins_password
  controller_ad                = var.availability_domain_name == "" ? data.oci_identity_availability_domains.ADs.availability_domains[var.availability_domain_number]["name"] : var.availability_domain_name
  controller_subnet_id         = oci_core_subnet.my_jenkins_subnet.id
  controller_image_id          = lookup(data.oci_core_images.jenkins_image.images[0], "id")
  controller_shape             = var.jenkins_instance_shape
  controller_flex_shape_ocpus  = var.flex_shape_ocpus
  controller_flex_shape_memory = var.flex_shape_memory
  controller_assign_public_ip  = true
  controller_display_name      = "jenkinsvm"
  plugins                      = var.plugins
  agent_count                  = 0
  ssh_authorized_keys          = tls_private_key.public_private_key_pair.public_key_openssh
  ssh_private_key              = tls_private_key.public_private_key_pair.private_key_pem
  http_port                    = var.jenkins_http_port
}


module "oci-oke" {
  source                        = "github.com/oracle-quickstart/oci-oke"
  tenancy_ocid                  = var.tenancy_ocid
  compartment_ocid              = var.compartment_ocid
  oke_cluster_name              = var.oke_cluster_name
  node_shape                    = var.oke_node_shape
  node_ocpus                    = var.oke_node_ocpus
  node_memory                   = var.oke_node_memory
  node_count                    = var.oke_node_count
  k8s_version                   = var.oke_k8s_version
  use_existing_vcn              = true
  vcn_id                        = oci_core_vcn.my_vcn.id
  is_api_endpoint_subnet_public = false
  api_endpoint_subnet_id        = oci_core_subnet.my_api_endpoint_subnet.id
  is_lb_subnet_public           = true
  lb_subnet_id                  = oci_core_subnet.my_lb_subnet.id
  is_nodepool_subnet_public     = false
  nodepool_subnet_id            = oci_core_subnet.my_nodepool_subnet.id
  ssh_public_key                = tls_private_key.public_private_key_pair.public_key_openssh
  availability_domain           = var.availability_domain_name == "" ? data.oci_identity_availability_domains.ADs.availability_domains[var.availability_domain_number]["name"] : var.availability_domain_name
}
