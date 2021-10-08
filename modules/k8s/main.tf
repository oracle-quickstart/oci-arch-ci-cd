## Copyright © 2020, Oracle and/or its affiliates. 
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

resource "oci_containerengine_cluster" "test_cluster" {
  #Required
  compartment_id     = var.compartment_ocid
  kubernetes_version = var.oke_cluster["k8s_version"]
  name               = var.oke_cluster["name"]
  vcn_id             = var.vcn

  #Optional
  options {
    service_lb_subnet_ids = [var.clustersub1_id]

    #Optional
    add_ons {
      #Optional
      is_kubernetes_dashboard_enabled = var.cluster_options_add_ons_is_kubernetes_dashboard_enabled
      is_tiller_enabled               = var.cluster_options_add_ons_is_tiller_enabled
    }

    kubernetes_network_config {
      #Optional
      pods_cidr     = var.oke_cluster["pods_cidr"]
      services_cidr = var.oke_cluster["services_cidr"]
    }
  }
}

resource "oci_containerengine_node_pool" "test_node_pool" {
  #Required
  cluster_id         = oci_containerengine_cluster.test_cluster.id
  compartment_id     = var.compartment_ocid
  kubernetes_version = var.oke_cluster["k8s_version"]
  name               = var.oke_cluster["pool_name"]
  node_shape         = var.oke_cluster["node_shape"]

  #Optional
  initial_node_labels {
    #Optional
    key   = var.node_pool_initial_node_labels_key
    value = var.node_pool_initial_node_labels_value
  }

  node_source_details {
    #Required
    #image_id    = data.oci_containerengine_node_pool_option.test_node_pool_option.sources.0.image_id
    #source_type = data.oci_containerengine_node_pool_option.test_node_pool_option.sources.0.source_type
    image_id = data.oci_core_images.alternative_node_image.images[0].id
    source_type = "IMAGE"
  }
  
  ssh_public_key = chomp(file(var.ssh_public_key))

  node_config_details {
    placement_configs {
      availability_domain = lookup(data.oci_identity_availability_domains.ads.availability_domains[var.availability_domain - 2],"name")
      subnet_id           = var.nodesub1_id
    }
    
    size = 3
  }

  dynamic "node_shape_config" {
    for_each = length(regexall("Flex", var.oke_cluster["node_shape"])) > 0 ? [1] : []
    content {
      ocpus         = var.oke_cluster["node_ocpus"]
      memory_in_gbs = var.oke_cluster["node_memory"]
    }
  }

}


