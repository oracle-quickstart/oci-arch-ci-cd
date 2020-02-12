# Continuous Integration (CI) and Continuous Deployment (CD)
A deployable solution for CI/CD using Jenkins on Oracle Cloud Infrastructure.


## Pre-Requisites

- You need an Oracle cloud account. Sign up here to create a free trial on OCI - [OCI free trial link](https://www.oracle.com/cloud/free/)

- Terraform — use the link to download terraform. Choose the operating systems you plan to work on - [Terraform download](https://www.terraform.io/downloads.html)

- Follow the steps in the video link to install terrafor - [Install Terraform](https://learn.hashicorp.com/terraform/getting-started/install.html)

(Note that, for linux and mac install steps are similar, except the file to be edited shown in the video link is —> `profile` for linux and `bash_profile` for mac)

Verify terraform is installed successfully using below command.

`terraform --version`

## Deploying the solution

### Step 1: Updating the configuration files

This solution uses Terraform to spin up the infrastructure.

Go ahead and clone this repo using below command.

`git clone https://github.com/oracle-quickstart/oci-arch-ci-cd.git`

Once you clone, open in your machine using your favorite editor. (Vim, Sublime, VSCode, Atom etc.)

In the opened editor, edit the file `env.sh` to fill in the details specific to your account on OCI.

#### *** Optional Step ***

In `vars.tf` file, if you would like to change default values provided for terraform variables, please go ahead and update it.

When all the variables are set, you are ready to run the terraform script.

### Step 2: Running the script for infrastructure provisioning

On the terminal or command line, make sure you are inside the working directory. If not, cd into the folder `oci-arch-ci-cd` using below command

`cd oci-arch-ci-cd`

Let’s export all the variables from `env.sh` into current directory.

`source env.sh`

Initialize terraform using below command

`terraform init`

Plan the terraform using below command

`terraform plan`

Apply Terraform using below command

`terraform apply`

It will prompt ***Enter a value***. Type ***yes***

This will start creating the resources on OCI and might take ~30 min to finish the job.

The terraform script creates all the necessery infrastructure components including  Networking, Jenkins server and OKE on OCI.

Once it completes, you should be able to login to OCI and see all the resources provisioned as expected in terraform.

### Step 2: Installing OCI-CLI on Jenkins Server

To install OCI-CLI on Jenkins, login to jenkins server that was created in the above step.

`ssh -i <private-key> opc@<public-ip-of-jenkins-instance>`



## Testing

Go to created resource load balancer and grab it’s public IP.

Open up your favorite browser (Chrome, Firefox etc.) and type `http://<public_ip>/api/`

You should be able to see a web page displayed that fetches the data from Oracle database.

Now, to check if its highly available, go ahead and delete one of the compute instances. Since we have a load balancer deployed, we should still be able to get the response from another running compute instance.

Let’s test it again on the browser. On the browser type `http://<public_ip>/api/`

You should still be able to get a response displaying the same web page you saw earlier. This suggest that our app is highly available even in case of the failure of the other instance. If you were to delete both the instances you should get an error on browser which means our app is no longer available.

Finally, if you like to destroy all the created resources, run below command.

`terraform destroy`

It will prompt ***Enter a value***. Type ***yes***

This completes the deployment.