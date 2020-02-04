output "id" {
  value = "${oci_core_instance.TFJenkinsMaster.id}"
}

output "private_ip" {
  value = "${oci_core_instance.TFJenkinsMaster.private_ip}"
}

output "public_ip" {
  value = "${oci_core_instance.TFJenkinsMaster.public_ip}"
}
