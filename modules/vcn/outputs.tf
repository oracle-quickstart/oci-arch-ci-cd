# Output variables from created vcn

output "vcn_id" {
  value = "${oci_core_virtual_network.vcn.id}"
}

output "subnet1_ocid" {
  value = "${oci_core_subnet.subnet_1.id}"
}

output "subnet2_ocid" {
  value = "${oci_core_subnet.subnet_2.id}"
}