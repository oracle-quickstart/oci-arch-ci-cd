## Copyright © 2020, Oracle and/or its affiliates. 
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

# Output variables from created vcn

output "vcn_id" {
  value = oci_core_virtual_network.vcn.id
}

output "subnet1_ocid" {
  value = oci_core_subnet.subnet_1.id
}

output "subnet2_ocid" {
  value = oci_core_subnet.subnet_2.id
}