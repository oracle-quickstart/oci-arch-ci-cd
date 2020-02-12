#!/bin/bash
set -e -x

sudo echo "OCI CLI Install"

printf 'y\n' | sudo yum install python-pip
sudo pip install oci-cli --upgrade

sleep 10

function waitForJenkins() {
    echo "Waiting for Jenkins to launch on ${http_port}..."

    while ! timeout 1 bash -c "echo > /dev/tcp/localhost/${http_port}"; do
      sleep 1
    done

    echo "Jenkins launched"
}

sudo echo "Java Install"

# Install Java for Jenkins
sudo yum -y update || true
sudo yum -y install java

sleep 10

# Install xmlstarlet used for XML config manipulation curl -L -O https://raw.githubusercontent.com/oracle/oci-cli/master/scripts/install/install.sh chmod +x install.sh
sudo yum install -y xmlstarlet

sudo echo "step -> docker install"

sudo yum -y update || true
sudo yum install -y java git docker-engine
sudo systemctl start docker
sudo systemctl enable docker

sleep 10

sudo echo "Installing jenkins"

# Install Jenkins
sudo echo "[jenkins-ci-org-${jenkins_version}]"
sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
sudo yum install -y jenkins-${jenkins_version}

# Config Jenkins Http Port
sudo sed -i '/JENKINS_PORT/c\ \JENKINS_PORT=\"${http_port}\"' /etc/sysconfig/jenkins
sudo sed -i '/JENKINS_JAVA_OPTIONS/c\ \JENKINS_JAVA_OPTIONS=\"-Djenkins.install.runSetupWizard=false -Djava.awt.headless=true\"' /etc/sysconfig/jenkins
# Start Jenkins
sudo service jenkins restart
sudo chkconfig --add jenkins

# Set httpport on firewall
sudo firewall-cmd --zone=public --permanent --add-port=${http_port}/tcp
sudo firewall-cmd --zone=public --permanent --add-port=443/tcp
sudo firewall-cmd --reload

waitForJenkins

# UPDATE PLUGIN LIST
curl  -L http://updates.jenkins-ci.org/update-center.json | sed '1d;$d' | curl -X POST -H 'Accept: application/json' -d @- http://localhost:${http_port}/updateCenter/byId/default/postBack

sleep 10

waitForJenkins

# INSTALL CLI
sudo cp /var/cache/jenkins/war/WEB-INF/jenkins-cli.jar /var/lib/jenkins/jenkins-cli.jar

sleep 10

# Initialize Jenkins User Password Groovy Script
export PASS=${jenkins_password}

sudo -u jenkins mkdir -p /var/lib/jenkins/init.groovy.d
sudo mv /home/opc/default-user.groovy /var/lib/jenkins/init.groovy.d/default-user.groovy

sudo service jenkins restart

waitForJenkins

sleep 10

# INSTALL PLUGINS
sudo java -jar /var/lib/jenkins/jenkins-cli.jar -s http://localhost:${http_port} -auth admin:$PASS install-plugin ${plugins}

# RESTART JENKINS TO ACTIVATE PLUGINS
sudo java -jar /var/lib/jenkins/jenkins-cli.jar -s http://localhost:${http_port} -auth admin:$PASS restart



