## Copyright © 2020, Oracle and/or its affiliates. 
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

data "oci_identity_availability_domains" "ads" {
  compartment_id = var.tenancy_ocid
}

data "oci_containerengine_cluster_option" "test_cluster_option" {
  cluster_option_id = "all"
}

data "oci_containerengine_node_pool_option" "test_node_pool_option" {
  node_pool_option_id = "all"
}

# Get the latest Oracle Linux image - temporary fix for node_pool_option image incompatibility
data "oci_core_images" "alternative_node_image" {
  compartment_id           = var.compartment_ocid
  shape                    = var.oke_cluster["node_shape"]
  operating_system         = var.oke_cluster["node_os"]
  operating_system_version = var.oke_cluster["node_os_version"]

  filter {
    name   = "display_name"
    values = ["^.*Oracle[^G]*$"]
    regex  = true
  }
}