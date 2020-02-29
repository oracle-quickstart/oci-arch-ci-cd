## Copyright © 2020, Oracle and/or its affiliates. 
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

output "master_private_ip" {
  value = module.jenkins-master.private_ip
}

output "master_login_url" {
  value = "http://${module.jenkins-master.public_ip}:${var.http_port}"
}