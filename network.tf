## Copyright © 2021, Oracle and/or its affiliates. 
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

resource "oci_core_vcn" "my_vcn" {
  cidr_block     = var.vcn_cidr
  compartment_id = var.compartment_ocid
  display_name   = "my_vcn"
  dns_label      = "myvcn"
}

resource "oci_core_service_gateway" "my_sg" {
  compartment_id = var.compartment_ocid
  display_name   = "my_sg"
  vcn_id         = oci_core_vcn.my_vcn.id
  services {
    service_id = lookup(data.oci_core_services.AllOCIServices.services[0], "id")
  }
}

resource "oci_core_nat_gateway" "my_natgw" {
  compartment_id = var.compartment_ocid
  display_name   = "my_natgw"
  vcn_id         = oci_core_vcn.my_vcn.id
}

resource "oci_core_route_table" "my_rt_via_natgw_and_sg" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.my_vcn.id
  display_name   = "my_rt_via_natgw"

  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_nat_gateway.my_natgw.id
  }

  route_rules {
    destination       = lookup(data.oci_core_services.AllOCIServices.services[0], "cidr_block")
    destination_type  = "SERVICE_CIDR_BLOCK"
    network_entity_id = oci_core_service_gateway.my_sg.id
  }
}

resource "oci_core_internet_gateway" "my_igw" {
  compartment_id = var.compartment_ocid
  display_name   = "my_igw"
  vcn_id         = oci_core_vcn.my_vcn.id
}

resource "oci_core_route_table" "my_rt_via_igw" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.my_vcn.id
  display_name   = "my_rt_via_igw"

  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_internet_gateway.my_igw.id
  }
}


resource "oci_core_security_list" "my_api_endpoint_subnet_sec_list" {
  compartment_id = var.compartment_ocid
  display_name   = "my_api_endpoint_subnet_sec_list"
  vcn_id         = oci_core_vcn.my_vcn.id

  # egress_security_rules

  egress_security_rules {
    protocol         = "6"
    destination_type = "CIDR_BLOCK"
    destination      = var.nodepool_subnet_cidr
  }

  egress_security_rules {
    protocol         = 1
    destination_type = "CIDR_BLOCK"
    destination      = var.nodepool_subnet_cidr

    icmp_options {
      type = 3
      code = 4
    }
  }

  egress_security_rules {
    protocol         = "6"
    destination_type = "SERVICE_CIDR_BLOCK"
    destination      = lookup(data.oci_core_services.AllOCIServices.services[0], "cidr_block")

    tcp_options {
      min = 443
      max = 443
    }
  }

  ingress_security_rules {
    protocol = "6"
    source   = var.nodepool_subnet_cidr

    tcp_options {
      min = 6443
      max = 6443
    }
  }

  ingress_security_rules {
    protocol = "6"
    source   = var.nodepool_subnet_cidr

    tcp_options {
      min = 12250
      max = 12250
    }
  }

  ingress_security_rules {
    protocol = "6"
    source   = "0.0.0.0/0"

    tcp_options {
      min = 6443
      max = 6443
    }
  }

  ingress_security_rules {
    protocol = 1
    source   = var.nodepool_subnet_cidr

    icmp_options {
      type = 3
      code = 4
    }
  }

}

resource "oci_core_security_list" "my_nodepool_subnet_sec_list" {
  compartment_id = var.compartment_ocid
  display_name   = "my_nodepool_subnet_sec_list"
  vcn_id         = oci_core_vcn.my_vcn.id

  egress_security_rules {
    protocol         = "All"
    destination_type = "CIDR_BLOCK"
    destination      = var.nodepool_subnet_cidr
  }

  egress_security_rules {
    protocol    = 1
    destination = "0.0.0.0/0"

    icmp_options {
      type = 3
      code = 4
    }
  }

  egress_security_rules {
    protocol         = "6"
    destination_type = "SERVICE_CIDR_BLOCK"
    destination      = lookup(data.oci_core_services.AllOCIServices.services[0], "cidr_block")
  }

  egress_security_rules {
    protocol         = "6"
    destination_type = "CIDR_BLOCK"
    destination      = var.api_endpoint_subnet_cidr

    tcp_options {
      min = 6443
      max = 6443
    }
  }

  egress_security_rules {
    protocol         = "6"
    destination_type = "CIDR_BLOCK"
    destination      = var.api_endpoint_subnet_cidr

    tcp_options {
      min = 12250
      max = 12250
    }
  }

  egress_security_rules {
    protocol         = "6"
    destination_type = "CIDR_BLOCK"
    destination      = "0.0.0.0/0"
  }

  ingress_security_rules {
    protocol = "All"
    source   = var.nodepool_subnet_cidr
  }

  ingress_security_rules {
    protocol = "6"
    source   = var.api_endpoint_subnet_cidr
  }

  ingress_security_rules {
    protocol = 1
    source   = "0.0.0.0/0"

    icmp_options {
      type = 3
      code = 4
    }
  }

  ingress_security_rules {
    protocol = "6"
    source   = "0.0.0.0/0"

    tcp_options {
      min = 22
      max = 22
    }
  }

}


resource "oci_core_security_list" "my_jenkins_subnet_sec_list" {
  compartment_id = var.compartment_ocid
  display_name   = "my_jenkins_subnet_sec_list"
  vcn_id         = oci_core_vcn.my_vcn.id

  egress_security_rules {
    destination = "0.0.0.0/0"
    protocol    = "6"
  }

  ingress_security_rules {
    tcp_options {
      max = 22
      min = 22
    }

    protocol = "6"
    source   = "0.0.0.0/0"
  }
  ingress_security_rules {
    tcp_options {
      max = var.jenkins_http_port
      min = var.jenkins_http_port
    }

    protocol = "6"
    source   = "0.0.0.0/0"
  }
  ingress_security_rules {
    tcp_options {
      max = var.jenkins_jnlp_port
      min = var.jenkins_jnlp_port
    }

    protocol = "6"
    source   = "0.0.0.0/0"
  }
}

resource "oci_core_subnet" "my_api_endpoint_subnet" {
  cidr_block                 = var.api_endpoint_subnet_cidr
  compartment_id             = var.compartment_ocid
  vcn_id                     = oci_core_vcn.my_vcn.id
  display_name               = "my_api_endpoint_subnet"
  security_list_ids          = [oci_core_vcn.my_vcn.default_security_list_id, oci_core_security_list.my_api_endpoint_subnet_sec_list.id]
  route_table_id             = oci_core_route_table.my_rt_via_natgw_and_sg.id
  prohibit_public_ip_on_vnic = true
}

resource "oci_core_subnet" "my_lb_subnet" {
  cidr_block     = var.lb_subnet_cidr
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.my_vcn.id
  display_name   = "my_lb_subnet"

  security_list_ids = [oci_core_vcn.my_vcn.default_security_list_id]
  route_table_id    = oci_core_route_table.my_rt_via_igw.id
}

resource "oci_core_subnet" "my_nodepool_subnet" {
  cidr_block     = var.nodepool_subnet_cidr
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.my_vcn.id
  display_name   = "my_nodepool_subnet"

  security_list_ids          = [oci_core_vcn.my_vcn.default_security_list_id, oci_core_security_list.my_nodepool_subnet_sec_list.id]
  route_table_id             = oci_core_route_table.my_rt_via_natgw_and_sg.id
  prohibit_public_ip_on_vnic = true
}

resource "oci_core_subnet" "my_jenkins_subnet" {
  cidr_block     = var.jenkins_subnet_cidr
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.my_vcn.id
  display_name   = "my_jenkins_subnet"
  dns_label      = "jenkins"

  security_list_ids = [oci_core_vcn.my_vcn.default_security_list_id, oci_core_security_list.my_jenkins_subnet_sec_list.id]
  route_table_id    = oci_core_route_table.my_rt_via_igw.id
}


