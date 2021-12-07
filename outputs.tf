## Copyright © 2021, Oracle and/or its affiliates. 
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

output "jenkins_public_ip" {
  value = module.jenkins.controller_public_ip
}

output "jenkins_login_url" {
  value = "http://${module.jenkins.controller_public_ip}:${var.jenkins_http_port}"
}

output "generated_ssh_private_key" {
  value     = tls_private_key.public_private_key_pair.private_key_pem
  sensitive = true
}