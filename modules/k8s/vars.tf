## Copyright © 2020, Oracle and/or its affiliates. 
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

variable "availability_domain" {}
variable "compartment_ocid" {}
variable "tenancy_ocid" {}
variable "vcn" {}
variable "oke_cluster" {
  type    = "map"
  default = {
    name           = "OKE_Cluster"
    k8s_version    = "v1.13.5"
    pool_name      = "Demo_Node_Pool"
    node_shape     = "VM.Standard2.1"
    pods_cidr      = "10.1.0.0/16"
    services_cidr = "10.2.0.0/16"
  }
}
variable "clustersub1_id" {}
variable "cluster_options_add_ons_is_kubernetes_dashboard_enabled" {
  default = true
}
variable "cluster_options_add_ons_is_tiller_enabled" {
  default = true
}
variable "node_pool_initial_node_labels_key" {
  default = "key"
}
variable "node_pool_initial_node_labels_value" {
  default = "value"
}
variable "ssh_public_key" {}

variable "nodesub1_id" {}


