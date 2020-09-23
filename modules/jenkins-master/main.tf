## Copyright © 2020, Oracle and/or its affiliates. 
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

# Init Script Files
data "template_file" "setup_jenkins" {
  template = "${file("${path.module}/scripts/setup.sh")}"

  vars = {
    jenkins_version  = var.jenkins_version
    jenkins_password = var.jenkins_password
    http_port        = var.http_port
    plugins          = join(" ", var.plugins)
  }
}

data "template_file" "init_jenkins" {
  template = "${file("${path.module}/scripts/default-user.groovy")}"

  vars = {
    jenkins_password = var.jenkins_password
  }
}

## JENKINS MASTER INSTANCE
resource "oci_core_instance" "TFJenkinsMaster" {
  availability_domain = lookup(data.oci_identity_availability_domains.ads.availability_domains[var.availability_domain - 2],"name")
  compartment_id      = var.compartment_ocid
  shape               = var.instance_shape
  display_name        = var.master_display_name

  create_vnic_details {
    subnet_id        = var.subnet_id
  }

   metadata = {
    ssh_authorized_keys = chomp(file(var.ssh_public_key))
  }

 source_details {
    source_type             = "image"
    source_id               = data.oci_core_images.InstanceImageOCID.images[0].id
    boot_volume_size_in_gbs = "50"
  }

  provisioner "file" {
    connection {
      host        = oci_core_instance.TFJenkinsMaster.public_ip
      agent       = false
      timeout     = "5m"
      user        = var.instance_user
      private_key = chomp(file(var.ssh_private_key))
    }

    content     = data.template_file.setup_jenkins.rendered
    destination = "~/setup.sh"
  }

  provisioner "file" {
    connection {
      host        = oci_core_instance.TFJenkinsMaster.public_ip
      agent       = false
      timeout     = "5m"
      user        = var.instance_user
      private_key = chomp(file(var.ssh_private_key))
    }

    content     = data.template_file.init_jenkins.rendered
    destination = "~/default-user.groovy"
  }

  provisioner "remote-exec" {
    connection {
      host        = oci_core_instance.TFJenkinsMaster.public_ip
      agent       = false
      timeout     = "5m"
      user        = var.instance_user
      private_key = chomp(file(var.ssh_private_key))
    }

    inline = [
      "chmod +x ~/setup.sh",
      "sudo ~/setup.sh > /tmp/c1output1.txt",
    ]
  }

  timeouts {
    create = "10m"
  }
}
