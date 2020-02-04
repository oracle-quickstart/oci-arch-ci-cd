variable "compartment_ocid" {}
variable "vcn" {}
variable "clustersub1_id" {}
variable "clustersub2_id" {}
variable "nodesub1_id" {}
variable "nodesub2_id" {}
variable "oke_cluster" {
  type    = "map"
  default = {
    name           = "OKE_Cluster"
    k8s_version    = "v1.13.5"
    pool_name      = "Demo_Node_Pool"
    node_image     = "Oracle-Linux-7.5"
    node_shape     = "VM.Standard2.2"
    pods_cidr      = "10.1.0.0/16"
    services_cidr = "10.2.0.0/16"

  }
}

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

variable "node_pool_quantity_per_subnet" {
  default = 3
}
