/*--------------------------------------------------------------------------------
    CLUSTERS
--------------------------------------------------------------------------------*/

resource "oci_containerengine_cluster" "demo_cluster" {
  #Required
  compartment_id     = "${var.compartment_ocid}"
  kubernetes_version = "${var.oke_cluster["k8s_version"]}"
  name               = "${var.oke_cluster["name"]}"
  vcn_id             = "${var.vcn}"

  #Optional
  options {
    service_lb_subnet_ids = ["${var.clustersub1_id}", "${var.clustersub2_id}"]

    #Optional
    add_ons {
      #Optional
      is_kubernetes_dashboard_enabled = "${var.cluster_options_add_ons_is_kubernetes_dashboard_enabled}"
      is_tiller_enabled               = "${var.cluster_options_add_ons_is_tiller_enabled}"
    }

    kubernetes_network_config {
        #Optional
        pods_cidr     = "${var.oke_cluster["pods_cidr"]}"
        services_cidr = "${var.oke_cluster["services_cidr"]}"
    }
  }
}

/*--------------------------------------------------------------------------------
    NODES 
--------------------------------------------------------------------------------*/

resource "oci_containerengine_node_pool" "demo_node_pool" {
  #Required
  cluster_id         = "${oci_containerengine_cluster.demo_cluster.id}"
  compartment_id     = "${var.compartment_ocid}"
  kubernetes_version = "${var.oke_cluster["k8s_version"]}"
  name               = "${var.oke_cluster["pool_name"]}"
  node_image_name    = "${var.oke_cluster["node_image"]}"
  node_shape         = "${var.oke_cluster["node_shape"]}"
  subnet_ids         = ["${var.nodesub1_id}", "${var.nodesub2_id}"]

  #Optional
  initial_node_labels {
    #Optional
    key   = "${var.node_pool_initial_node_labels_key}"
    value = "${var.node_pool_initial_node_labels_value}"
  }

  quantity_per_subnet = "${var.node_pool_quantity_per_subnet}"
#  ssh_public_key      = "${var.node_pool_ssh_public_key}"
}


/*--------------------------------------------------------------------------------
    OUTPUTS 
--------------------------------------------------------------------------------*/

output "cluster" {
  value = {
    id                 = "${oci_containerengine_cluster.demo_cluster.id}"
    kubernetes_version = "${oci_containerengine_cluster.demo_cluster.kubernetes_version}"
    name               = "${oci_containerengine_cluster.demo_cluster.name}"
  }
}

output "node_pool" {
  value = {
    id                 = "${oci_containerengine_node_pool.demo_node_pool.id}"
    kubernetes_version = "${oci_containerengine_node_pool.demo_node_pool.kubernetes_version}"
    name               = "${oci_containerengine_node_pool.demo_node_pool.name}"
    subnet_ids         = "${oci_containerengine_node_pool.demo_node_pool.subnet_ids}"
  }

}

data "oci_containerengine_cluster_option" "demo_cluster_option" {
  cluster_option_id = "all"
}

data "oci_containerengine_node_pool_option" "demo_node_pool_option" {
  node_pool_option_id = "all"
}

output "cluster_kubernetes_versions" {
  value = ["${data.oci_containerengine_cluster_option.demo_cluster_option.kubernetes_versions}"]
}

output "node_pool_kubernetes_version" {
  value = ["${data.oci_containerengine_node_pool_option.demo_node_pool_option.kubernetes_versions}"]
}

