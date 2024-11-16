#####################################################################################
# Jenkins Codes on AWS EC2
#####################################################################################

# Jenkins is a tool that is used for CI (which is part of CI-CD)
# Continuous Integration is a framework as part of software development with the following steps:
# Having written the code, CI does the following: 1.compiling 2. unit testing 3. packaging
# 1. Compiling: converting your code (HLL) to assembly language (LLL)
# 2. Unit testing: checking that the compiled code has no errors
# 3. Packaging: creating an artifact/executible of your code for end user, this depends on the language of your code. (if Java, .war or .jar) 
# To perform all this steps, we use Jenkins, along with a plugin depending on the language.
# Plugins: Java - Maven; .Net - MSBuild; Python - Ant; Php - Gradle 

# Continuous Deployment is a framework as part of software development
# Here, all the steps in CI are finally deployed/executed to run on a server
# Deployment can happen on a VM, Cloud, Containers
# Deployment can also be done using Jenkins, along with a plugin depending on where to deploy
# Plugins: VM - Ansible; Cloud/Container - Kubernetes/Docker

# Jenkins is platform independent, can run on any system (windows, mac, linux).
# Only dependency it requires is Java 11 or Java 17 (as Jenkins has been built on Java)

# Other tools like Jenkins:
# Gitlabs, Github Actions, Concourse, CircleCI, Bitbucket Pipelines


# Use this link to install Jenkins on AWS: https://www.jenkins.io/doc/tutorials/tutorial-for-installing-jenkins-on-AWS/

# Starting Jenkins on AWS EC2
# Launch EC2 Cluster (Select all port options under security groups)

# After launching EC22 terminal, check if Java is installed.
java --version

# Update your yum package manager
sudo yum update -y

# Install Java 11
sudo dnf install java-11-amazon-corretto -y

# copy the Jenkins repo
sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo

# Import a key file from Jenkins-CI to enable installation from the package:
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key

# Finally check if any upgrades are needed
sudo yum upgrade

# Install Jenkins
sudo yum install jenkins -y

# Enable the Jenkins service to start at boot:
sudo systemctl enable jenkins

# Start Jenkins as a service:
sudo systemctl start jenkins

# Check if Jenkins has started
systemctl status jenkins

# In order to use Jenkins for CI/CD, it comes with a GUI on web browser for ease of use
# In order to enable that, we need to set up port-forwarding specifically for Jenkins
# Jenkins Service Port # 8080
# Other common Port #: HTTP:80, SSH:22, HTTPS:443

# To enable Jenkins Port
# Go to the EC2 instance details -> Security -> Click on Security Group
# Click Edit Inbound Rules -> Add Rule
# [Custom TCP, 8080, AnywhereIPv4]
# Save Rule

# We need to access Jenkins over a Public IP. To get the public IP of your EC2 system:
curl ifconfig.me
# E.g. 52.66.99.149

# Now to access the PublicIP, open web browser and enter Url 
# 52.66.99.149:8080

# To access Jenkins on the browser, a password is needed which is stored in your EC2 system.
# To access password:
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
# Copy password and paste in web UI

# Getting Started with Jenkins
# Choose Install suggested plugins
# Then, Create Admin User - Provide your own credentials
# e.g. username: vyom_bhatt, password: jenkins_pwd, full name: Vyom Bhatt, email: vyom_bhatt@yahoo.com
# Jenkins is ready!

# On the EC2, the home location for jenkins is: 
cd /var/lib/jenkins/

# To see all plugins on Jenkins: plugins.jenkins.io
# To download on Jenkins: Manage Jenkins -> Plugins -> Available Plugins -> {Search and Install Plugin e.g Maven}
# After installing a plugin, we need to configure it.
# To configure a plugin: Manage Jenkins -> Tools -> Maven Installations - Add Maven ->

# Jenkins can be used to build projects one time or periodically
# Click on Build Triggers to run a code or to schedule a code periodically
# There is an option for poll SCM when scheduling codes. 
# Here, the code gets triggered only when a specified github repo is updated (push has happened)
# For all jobs, you can send an email notification on execution/failure under Post Build Actions



