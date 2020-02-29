## Copyright © 2020, Oracle and/or its affiliates. 
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

# Get list of availability domains

data "oci_identity_availability_domains" "ads" {
  compartment_id = var.tenancy_ocid
}