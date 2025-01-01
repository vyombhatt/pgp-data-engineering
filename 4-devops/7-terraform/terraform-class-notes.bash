#####################################################################################
# Creating a docker instance in EC2 and installing Terraform in Amazon Linux
#####################################################################################

# Connect to an EC2 server and launch an instance

# For you to access aws through IaC, you need to make sure a user is created in aws.
# Navigate to IAM > Users > Create user
# User Name: terraform-user (give any name) -> Next
# Select "Attach Permissions Directly" -> Search and Select "AdministratorAccess"
# -> Next -> Create User

# Now open the new user created - "terraform-user"
# Security credentials -> Select "Create access key" -> Select "Third party service"
# Description tag value = "Terraform key" (give any description)
# Select "Create access key"
# Select "Download .csv file" (Make sure to download as it will disappear once closed)

# Terraform installation instructions: https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli
# Install yum-config-manager to manage your repositories
sudo yum install -y yum-utils
# Use yum-config-manager to add the official HashiCorp Linux repository.
sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
# Install Terraform from the new repository.
sudo yum -y install terraform

# check installed version
terraform --version

# Create a separate directory
mkdir demoterraform
cd demoterraform/
ls -al

# Create first terraform script
# We can also take the approach of creating the main.tf, variables.tf, output.tf, provider.tf files.
# Here we will instead just create one file 
vi demo.tf

# Initialize the terraform working directory, .tf file should be in pwd
terraform init
ls -al
# A new folder .terraform will now be created where all necessary plugins will have been downloaded

# Validating the terraform script
terraform validate

# Format the style of the script
terraform fmt

# Generate a plan to understand what the .tf script will do
terraform plan

# Finally, execute the script and create the defined resources
terraform apply # reply "yes" to the prompt

# fetches running resource information from the .tfstate
terraform show

# deleting all resources created
terraform destroy

#####################################################################################
# Generate ssh-key-pairs for adding it to cluster resources in .tf script
#####################################################################################

# We need to create a new user and generate new keys
# Create a new user with the name "demouser"
sudo useradd demouser
# Generate a password for the user
sudo passwd demouser
# After running this, machine will prompt to enter password. Hit enter without typing so that no password is set

# We need to provide sudo access to this user
# In order to do this, we need to update the file /etc/sudoers in the SLAVE node
cd /etc/ # go to folder
sudo vi sudoers # open sudoers in a text editor
/wheel # searches for the word "wheel" in the file
# press [ESC]+[i] for going to write mode and write the following
# demouser ALL=(ALL) NOPASSWD: ALL
# Press [CTRL]+[c]
# Type :wq! to save and exit the editor

# Now, we need to generate a public and private key
su - demouser # log in to the user
ssh-keygen # command to generate keypairs

# To check whether the keys have been generated
cd .ssh
ls -al # here 2 files will be created, 1.id_res (private key) 2.ide_res.pub (public key)

# The public key file path "/home/demouser/.ssh/id_rsa.pub" is added to resources in .tf file

# Finally re-run the above terraform commands to create resource

# For all additional resources like security groups, storage etc. refer to the terraform documentation:
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs