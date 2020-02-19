#!/bin/bash
sudo runuser -l opc -c "kubectl create secret docker-registry newsecret --docker-server=<Region-Prefix-Name> --docker-username='<username-for-tenancy>'> --docker-password='<OCIR-TOKEN>' --docker-email='a@b.com'"
sudo runuser -l opc -c "sudo docker login -u 'username-for-tenancy' -p '<OCIR-TOKEN>' <Region-Prefix-Name>"
sudo runuser -l opc -c 'kubectl apply -f /var/lib/jenkins/hello.yml'
