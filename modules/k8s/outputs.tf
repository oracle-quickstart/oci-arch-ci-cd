output "cluster" {
  value = {
    id                 = "${oci_containerengine_cluster.test_cluster.id}"
    kubernetes_version = "${oci_containerengine_cluster.test_cluster.kubernetes_version}"
    name               = "${oci_containerengine_cluster.test_cluster.name}"
  }
}

output "node_pool" {
  value = {
    id                 = "${oci_containerengine_node_pool.test_node_pool.id}"
    kubernetes_version = "${oci_containerengine_node_pool.test_node_pool.kubernetes_version}"
    name               = "${oci_containerengine_node_pool.test_node_pool.name}"
  }
}