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

### Step 3: Configure OCI-CLI and Sudo user on Jenkins Instance

Go to OCI console -> Compute -> Instances.

You should be able to see the instance `Jenkins-Master-Node`

Copy the public-ip of the instance. ssh into the instance using below command

`ssh -i <path-to-ssh-private-key> opc@<public-ip-of-jenkins-instance>`

once you are logged in, make sure OCI-CLI is installed using 

`oci -v`

Next, enter the command `oci setup config`

Press Enter when prompted for directory name to accept the default. 
Enter the details about tenancy OCID, user OCID.
Enter `Y` for `New RSA key pair`. Press Enter and accept default options for directories. 
Press Enter when prompted for passphrase so as to leave it blank.

Verify all the files exists by checking in -> `cd /home/opc/.oci` and then `ls`.

Also, do `cat config` and make sure all the details about tenancy are correct.

Now, do `cat oci_api_key_public.pem` and copy the key contents. 

Login to OCI console, go to your profile and user. Click on `Add Public Key` and copy paste the contents of the file copied in last step. Now make sure the `fingerprint` generated is same as the one in Jenkins server `/home/opc/.oci/nfig` file. 

Next, to add sudo user to Jenkins Server, on terminal of logged in Jenkins server, do

`sudo visudo -f /etc/sudoers.d/filename`

Press `i` for insert mode. Now we just need to include the relevant line in our file:

`jenkins ALL=(ALL) NOPASSWD: ALL`

Save and Exit from edit mode,

`Press ESC and type :wq and hit Enter`. You should be out of the edit mode.

We are done.

### Step 4: Configure OCI tenancy details on Jenkins UI

Go to OCI console -> Compute -> Instances.

You should be able to see the instance `Jenkins-Master-Node`

Copy the public-ip of the instance. Open a browser and enter <public-ip of the instance>:8080

This should give you a Jenkins UI. Login using username as `admin` and password as specified in vars.tf file.

```WARNING make sure this step is right
On the Jenkins UI, In Manage Jenkins screen, Click Configure System, Scroll Down and locate `Cloud`. Click on `a separate configuration page. Now, select `drop down arrow under Add a new cloud`. Click `Oracle Cloud Infrastructure Compute`. New dialog box will appear. Enter `Name: <Use easy to remember name>`. Next to `Credentials` click on `Add` and from the dopdown select `Jenkins`.

This opens up a dialog box. Keep the `Domain` as it is. 
For Kind, Choose `Oracle Cloud Infrastructure Credentials`.

For rest,

Fill out the dialog box:
Name: Use easy to remember name
Fingerprint: Copy/paste OCI_api_key_fingerprint value from the config file saved in step 3.
APIKey: Copy/paste oci_api_key.pem file content from the config file saved in step 3.
PassPhrase: Leave empty
Tenant Id: Copy/paste Tenant OCID.
User Id: Copy/paste User OCID.
Region: Type your region Name (Shown in OCI console window, us-ashburn-1 etc)
Click Test Connection and verify ‘Successful’ message. We have now verified connectivityto OCI via the Jenkins compute node.
```

Finally, come down and make sure to click on `Save`.

## Step 5: Configure Github webhook

Go to the repo https://github.com/KartikShrikantHegde/jenkins-helloworld. Fork it. 

Go to settings on the right side of the repo. Then on the left, click on webhooks. 

You should see an option to add webhook. click on it. 

For payload URL enter -> `http://<public-ip of the instance:8080/github-webhook/`

For content type, choose -> application/json

Leave the secret field blank.

For Which events would you like to trigger this webhook -> select `send me everything`

Add webhook and you are done.

## Step 6: Generate github token

Now click on your github account profile, click on settings.

On the left side, you will see an option `Developer settings`. Click on it.

Again on the left, click on `Personal access tokens`. Click `Generate new token`.

Enter a note, select all the options under `Select scopes` and click on `Generate token` at the bottom.

This will generate a one time token. So please copy and save it for future steps.

## Step 7: Add the github token to Jenkins UI

On the Jenkins UI, In Manage Jenkins screen, Click Configure System, Scroll Down and you will see `GitHub` section.

Under that, Click on `Add Github Server` and then `Github Server` from the dropdown. This opens up a window.
Enter the details.

Name -> `Specify a name`
API URL -> `https://api.github.com`
Credentials -> Click on `Add button` and then `Jenkins` under the dropdown. This opens a new window. 

Here, change the Kind to `Secret Text`.
Under Secret -> Enter the access token that was generated in the previous step. Click on `Add`.

Click on Test connection and it should show `Credentials verified for <user>`. So now our Jenkins can access our repo.

Check right mark on the Manage hooks. On the bottom click on `Save`.

## Step 8: Generate OCIR token

Login to OCI console.

Click on your `profile` -> `User Settings`. On the bottom left, click on `Auth Tokens`. Click on `Generate Token`.

Provide a discription and then hit `Generate Token`. This will generate a token. Make sure to copy the token for future steps.

## Step 9: Update deployment files and copy to jenkins server

In your working directory, you should be able to see 2 files `hello-deploy.sh` and `hello.yaml` along with terraform files.

Open both the files and add in details related to your tenancy where necessecary.

For `hello-deploy.sh`, update details for these fields.

<Region-Prefix-Name> -> eg: iad.ocir.io (for ashburn region)
<username-for-tenancy> -> <your-tenancy-namespace>/oracleidentitycloudservice/abc@xyz.com (look for namespace in tenancy details for <your-tenancy-namespace>)
<OCIR-TOKEN> -> the token we generated in previous step

For `hello.yaml`, update
<Region-Prefix-Name> - eg: iad.ocir.io (for ashburn region)
<your-tenancy-namespace> -> look for namespace in tenancy details for <your-tenancy-namespace>

Once update, lets copy these files into jenkins server.

From your working directory where you have these files stored, copy the files into jenkins server using below commands.

`scp -i <private-key-for-instance> <path-to-working-directory>/hello-deploy.sh opc@<public-ip-of-instance>:/var/lib/jenkins/workspace`
`scp -i <private-key-for-instance> <path-to-working-directory>/hello.yml opc@<public-ip-of-instance>:/var/lib/jenkins/workspace`

## Step 10: Update Jenkinsfile in Github repo

Go to the forked Github repo from https://github.com/KartikShrikantHegde/jenkins-helloworld.

Next, in the repo, you should be able to find `Jenkinsfile`. Let's update the `Jenkinsfile`.

In the `Jenkinsfile`, go to `stage('Push image to OCIR')` and update details related to your tenancy.

<username-for-tenancy> -> <your-tenancy-namespace>/oracleidentitycloudservice/<abc@xyz.com (use your email here)> (look for namespace in tenancy details for <your-tenancy-namespace>)
<OCIR-TOKEN> -> the token we generated in previous step
<Region-Prefix-Name> -> eg: iad.ocir.io (for ashburn region)
<your-tenancy-namespace> -> look for namespace in tenancy details for <your-tenancy-namespace>

## Step 11: Install Kubectl and configure kube-config on Jenkins

ssh into Jenkins Server instance and install kubectl using below command and verify it's installed.

`curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl;chmod +x ./kubectl;sudo mv ./kubectl /usr/local/bin/kubectl;kubectl version --client`

 Now, to setup kubeconfig, go to your OCI tenancy. On the left hand side click on `Developer Services`. Select `Container Clusters (OKE)`. Click on the cluster created by terraform.

On the top, click on `Access Kubeconfig` and run the commands specified there inside the jenkins server where you have ssh'ed in. Once done, verify you can access the k8s nodes, by typing,

`kubectl get nodes`

You see details of the nodes running in the cluster. 

## Step 12: Create a pipeline using Blue Ocean

Finally, with all the configurations done, lets create the pipeline.

On the Jenkins UI,(refer step 4 on how to access Jenkins UI), on the left hand side, you should see `Open Blue Ocean`. Click on it. It opens a new page.

Select `New Pipeline`. Next select `Github`. If it asks for a token provide the Github token we generated in `step 6`. 

Next, select your profile. Search for the repo you had forked and made the changes. Hit `Create Pipeline`.

This creates a pipeline and starts the build and deploy steps. Once completed (indicated by green tick), you can go back to jenkins server and run below command.

`kubectl get services`

You see details of the services running on the nodes in the cluster. For the hello-service load balancer that you just deployed, you will see:
the external IP address of the load balancer (for example, 129.146.147.91)
the port number
Open a new browser window and enter the url to access the hello application in the browser's URL field. For example, http://129.146.147.91

You should be able to access the application.

Fron now on, any changes you make to the github code, triggers a new build and deploy by jenkins. This completes the CI/CD cycle.

## Step 12: Delete the resources

Finally, if you like to destroy all the created resources, run below command.

`terraform destroy`

It will prompt ***Enter a value***. Type ***yes***

This completes the deployment.