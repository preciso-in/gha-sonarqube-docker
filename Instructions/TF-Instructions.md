# Instructions to deploy a simple website on GCP with Jenkins and Terraform

---

Please refer to ./setup-instructions.md for instructions on

- Authenticating into GCP.
- Providing defaults for the script.
- Information on flags required by script

---

Switch to ./scripts folder on your terminal and follow instructions below.
You can update default values by changing default values listed in ./scripts/default-values.sh

```
> cd scripts
> chmod +x tf-create.sh
> export PATH=$PATH:${pwd}
> tf-create.sh
> source ./working/created-resource-names.sh
```

On completion of above instructions, 3 servers hosting Jenkins, Sonarqube and Docker will be created on GCP Compute Engine.

---

<details >
<summary>Open Jenkins Server</summary>

##### Check if Jenkins is running

> Login to Jenkins server and check service status

```
> gcloud compute ssh $(terraform output -raw jenkins-server-name)
ci-server:~$ systemctl status jenkins
```

##### Check if Jenkins is running

```
ci-server:~$ exit
```

##### Open Jenkins URL in Browser

```
> terraform output -raw jenkins-url
```

</details>

---

<details >
<summary>Jenkins Server Setup</summary>

##### Get Jenkins Initial Admin Password

```
> gcloud compute ssh $(terraform output -raw jenkins-server-name)
ci-server:~$ sudo cat /var/lib/jenkins/secrets/initialAdminPassword
```

##### Initial default plugins

> Browse to Jenkins IP Address
> Input Jenkins InitialAdminPassword
> Install Default plugins.

##### Create Jenkins User

```
user: Nilesh
pwd: 12345
```

##### Create Freestyle Project "Automated-Pipeline"

> Add Github details of git repo

```
https://github.com/nparkhe83/jenkins-sonarqube-docker.git
```

> Add branch specifier as "\*/main"
> Check "GitHub hook trigger for GITScm polling" in Build Trigger

##### Create Webhooks in Github

> Copy Jenkins Server URL into Payload URL

```
terraform output -raw jenkins-webhook-url
```

> In "Which events would you like to trigger this webhook?" > "Let me select individual events." > Select "Pushes" and "Pull Requests"

</details>

---

<details >

<summary>Start SonarQube server</summary>

##### Run Sonarqube on Sonarqube Server

```
> gcloud compute ssh $(terraform output -raw sonarqube-server-name)
scanner-server:~$ cd /usr/local/sonarqube-10.2.0.77647/bin/linux-x86-64/
scanner-server:~$ ./sonar.sh console
```

</details>

---

<details >
<summary>Open SonarQube Server</summary>

##### Open SonarQube Server in Browser

```
> terraform output -raw sonarqube-url
```

> user: admin
> pwd: admin
> Change password to 12345

##### Configure SonarQube Server

> Select Create Project Manually

```
Project Display Name = Onix-Website-Scan
Project Key = Onix-Website-Scan
Main Branch Name = Main
```

> Choose the baseline for new code for this project

```
Use the global setting.
Previous version
Any code that has changed since the previous version is considered new code.
Recommended for projects following regular versions or releases.
```

> Select CI Method

`Jenkins`

> Select Devops Platform

`Github`

> Analyze your project with Jenkins in Step 4

`Create a JenkinsFile - Choose Other (For JS, TS...)`

##### Create Token in SonarQube

> Go to Admin Profile at top right hand
> A > My Account > Security > Generate Token
> _Copy this token and keep it safe_
> ex. sqp_9d9c1f8c3631edaf75c1726a2bd7367e11547b81

```
Name: Jenkins-token
Type: Project Analysis Token
Project: Onix-Website-Scan
Expires in: 30 days
```

</details>

---

<details >
<summary>SonarQube integration in Jenkins Server</summary>

##### Install Jenkins Plugins

> Install

```
Sonarqube Scanner
SSH2 Easy
```

##### Configure Tools in Jenkins

> Jenkins Dashboard > Manage Jenkins > Tools > SonarQube Scanner Installations > "Add Sonarqube Scanner"

```
Name: SonarScanner
Check "Install Automatically"
```

##### Configure System in Jenkins

> Jenkins Dashboard > Manage Jenkins > System > SonarQube Servers > "Add Sonarqube"

```
Name: Sonar-server
Server URL: > terraform output -raw sonarqube-url
```

> In same section, add Sonarqube token
> Sonar Authentication Token > "Add" > "Jenkins"

```
Kind: Secret Text
Secret: [SONAR_TOKEN] ex.sqp_9d9c1f8c3631edaf75c1726a2bd7367e11547b81
ID: sonar-token
```

> Then select token in dropdown
> Sonar Authentication Token > "sonar-token" in dropdown

##### Create Buildstep in Pipeline

> Jenkins Dashboard > [JOB_NAME] > Configure > "Add Build Step" > "Execute SonarQube Scanner"

```
Analysis Properties: sonar.projectKey=Onix-Website-Scan
```

##### Run Pipeline

> Dashboard > [JOB_NAME] > "Build Now"

</details>

---

<details >
<summary>Docker Server Startup</summary>

##### Run Docker

> Check if Docker is running

```
> gcloud compute ssh $(terraform output -raw docker-server-name)
container-server:~$ sudo docker run hello-world
```

> Create password for Ubuntu user

```
container-server:~$ sudo passwd ubuntu
12345
```

</details>

---

<details>
<summary>Get access to Docker Server from Jenkins Server</summary>

##### Create SSH Access into Docker-Server on Jenkins server.

> Get Docker IP

```
> DOCKER_IP=$(terraform output -raw docker-server-ip)
```

> Switch to jenkins user on jenkins server

```
> gcloud compute ssh $(terraform output -raw jenkins-server-name)
ci-server:~$ sudo su jenkins
jenkins@ci-server:~$ ssh ubuntu@DOCKER_IP
```

> Add public key of Jenkins in Docker if not already done.

```
> gcloud compute ssh $(terraform output -raw docker-server-name)
jenkins:~$ sudo su // Switch to root user
root:~# vim /etc/ssh/sshd_config
```

> Edit sshd_config file

```
Uncomment PubkeyAuthentication yes
PasswordAuthentication yes
```

> Restart sshd service

```
root:~# systemctl restart sshd
```

> Try SSH again from jenkins server to ssh

```
jenkins@ci-server:~$ ssh ubuntu@$DOCKER_IP
// ssh contains IP address encoding. Hence, everytime, the IP address changes, you have to recreate the SSH key and paste it in the Jenkins config.
```

> Create a public and private key in Jenkins server

```
jenkins@ci-server:~$ ssh-keygen
```

> Add key to jenkins-server (To avoid typing password again)

```
jenkins@ci-server:~$ ssh-copy-id ubuntu@$DOCKER_IP
```

> Log into the Docker server and create a folder to save nginx site assets

```
jenkins@ci-server:~$ ssh ubuntu@DOCKER_IP
container-server:~$ mkdir website
```

> Grant ubuntu user access to run docker commands

```
container-server:~$ sudo usermod -aG docker ubuntu
container-server:~$ newgrp docker
container-server:~$ docker ps // This should run now.
```

</details>

---

<details >
<summary>Integrate Docker build step in Jenkins</summary>

##### Create Docker build step in Jenkins

> Dashboard > Manage Jenkins > System > Server groups > Server Group List

```
Group Name: Docker-Servers
SSH Port: 22
User Name: ubuntu
Password: 12345 // Password entered when we were in Docker server as root.
```

> Dashboard > Manage Jenkins > System > Server lists

```
Server Group: Docker-Servers
Server Name: Docker-1
Server IP: $DOCKER_IP
```

> Dashboard > [JOB_NAME] > Configure > Build Steps > "Add Build Step" > "Execute Shell"

```
Command: scp -r ./* ubuntu@$DOCKER_IP:~/website/
```

> Dashboard > [JOB_NAME] > Configure > Build Steps > "Add Build Step" > "Remote Shell"

```
Target Server: Docker-Servers~~Docker-1~~$DOCKER_IP //Dropdown
shell:
cd /home/ubuntu/website
docker build -t mywebsite .
docker run -d -p 8085:80 --name=Onix-Website mywebsite
```

</details>

---

<details >
<summary>Check Website </summary>

##### Go to Docker IP to check website

```
> terraform output docker-url
```

</details>
