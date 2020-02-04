output "master_instance_id" {
  value = "${module.jenkins-master.id}"
}

output "master_private_ip" {
  value = "${module.jenkins-master.private_ip}"
}

output "master_login_url" {
  value = "http://${module.jenkins-master.private_ip}:${var.http_port}"
}