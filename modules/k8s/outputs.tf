## Copyright © 2020, Oracle and/or its affiliates. 
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

output "cluster" {
  value = {
    id                 = oci_containerengine_cluster.test_cluster.id
    kubernetes_version = oci_containerengine_cluster.test_cluster.kubernetes_version
    name               = oci_containerengine_cluster.test_cluster.name
  }
}

output "node_pool" {
  value = {
    id                 = oci_containerengine_node_pool.test_node_pool.id
    kubernetes_version = oci_containerengine_node_pool.test_node_pool.kubernetes_version
    name               = oci_containerengine_node_pool.test_node_pool.name
  }
}