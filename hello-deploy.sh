## Copyright © 2020, Oracle and/or its affiliates. 
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

#!/bin/bash
sudo runuser -l opc -c "kubectl create secret docker-registry secret --docker-server=<region-prefix-name> --docker-username='<username>' --docker-password='<ocir-token>' --docker-email='a@b.com'"
sudo runuser -l opc -c "sudo docker login -u '<username>' -p '<ocir-token>' <region-prefix-name>"
sudo runuser -l opc -c 'kubectl apply -f /var/lib/jenkins/hello.yml'
