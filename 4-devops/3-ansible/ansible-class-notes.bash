#####################################################################################
# Creating a master machine-slave machine SSH connection 
#####################################################################################

# Create a Master and Slave EC2 Node on AWS - both should have python installed
# Code to check if python is installed
which python3

# Install Ansible only in the master node
sudo yum install -y ansible 
ansible --version # check version

# Default path where ansible will be located
cd /etc/ansible/

# Create a new user with the name "ansible" in the MASTER node
sudo useradd ansible
cat /etc/passwd # check whether the user has been created in this location
# Generate a password for the user
sudo passwd ansible
# After running this, machine will prompt to enter password. Hit enter without typing so that no password is set
# or set password: 123
# log in to the user
su - ansible
whoami # to check whether we have logged in to the user
exit # log out of the user


# Create a new user with the name "ansible" in the SLAVE node (same name as master node user)
sudo useradd ansible
cat /etc/passwd # check whether the user has been created in this location
# Generate a password for the user
sudo passwd ansible
# After running this, machine will prompt to enter password. Hit enter without typing so that no password is set
# log in to the user
su - ansible
whoami # to check whether we have logged in to the user
exit # log out of the user

# We need to provide sudo access to the ansible user in the SLAVE node.
# In order to do this, we need to update the file /etc/sudoers in the SLAVE node
cd /etc/ # go to folder
sudo vi sudoers # open sudoers in a text editor
/wheel # searches for the word "wheel" in the file
# press [ESC]+[i] for going to write mode and write the following
# ansible ALL=(ALL) NOPASSWD: ALL
# Press [CTRL]+[c]
# Type :wq! to save and exit the editor

# After doing the above, we will have sudo access for the user ansible in the slave node

# Now, we need to generate a public and private key in the MASTER node
su - ansible # log in to the user
ssh-keygen # command to generate keypairs

# To check whether the keys have been generated
cd .ssh
ls -al # here 2 files will be created, 1.id_res (private key) 2.ide_res.pub (public key)
cd ~ # go back to home dir

# In order to establish the ssh connection, we need the public IP of the SLAVE node
curl ifconfig.me # run this on slave node to get the public IP e.g. 3.111.149.212

# Connect to slave machine from the master machine
ssh ansible@3.111.149.212 # run this on the master node
# In case this throws a permission denied error, it will mainly be because we have not enabled ssh port in slave node

# Run this in SLAVE node to enable ssh port
cd /etc/ssh # go to ssh folder
sudo vi sshd_config # the file sshd_config has details that needs to be changed
/password # searches for the word "password" in the file
# scroll and look for the setting "PasswordAuthentication"
# press [ESC]+[i] and change the setting from "no" to "yes"
# Press [CTRL]+[c] and type :wq! to save and exit the editor
# After doing this, we need to restart the sshd service for the changes to be implemented
sudo systemctl restart sshd

# Now run this on the MASTER machine again
ssh ansible@3.111.149.212 # run this on the master node
# After doing this, we can take remote access of slave machine from the master machine
exit # to logout from the remote access and move back to the master machine

# Now that we have the access to the remote server, we need to copy the public key from master to remote server
ssh-copy-id ansible@3.111.149.212 # run this in the MASTER node
# This ensures we don't need a password to access slave servers from master

#####################################################################################
# Ansible specific codes
#####################################################################################

# All below codes are done in MASTER machine, because we installed ansible only in Master
# Checking all the ansible modules available
ansible-doc -l
ansible-doc -l | wc -l # count of all modules available

# Checking specific modules by providing alphanumeric filters
ansible-doc -l | grep -i user # shows all user-related modules
ansible-doc -l | grep -i azure # shows all azure-related modules

# Creating the ansible configuration file
# All ansible files are stored in /etc/ansible
cd /etc/ansible # move to this ansible dir
ansibile-config init --disable -t all > ansible.cfg # create the ansible configuration file

# Another way of creating the ansible configuration file
sudo vi ansible.cfg # this will create a blank ansible file, we will have to manually enter the configs
# After creating the ansible configuration file, enter the following configs in it
[defaults]
inventory = /etc/ansible/hosts.ini # this is the ansible inventory file
become = True # gives sudo privileges to ansible, givevn in sudo_method
become_method = sudo
become_user = root
fork = 5 # parallel execution, no. of servers at a time
timeout = 30 # seconds to time out ssh to a server
# Press [CTRL]+[c] and type :wq! to save and exit the editor

# After creating the ansible config file, we create the ansible inventory file
# default location: /etc/ansible/hosts.ini
sudo vi hosts.ini # open the text editor

[demo] # create a group named "demo" of all servers
3.111.149.212
# Press [CTRL]+[c] and type :wq! to save and exit the editor

# Running the ansible task, there are 2 ways: 1. Adhoc commands 2. Playbook

# Running adhoc command [in Master]
ansible -m ping demo # ping is an ansible module that checks if the server "demo" is online
# if successful, output will be shown in green. Output will show "ping:pong"
# if successful, but you made a change in the config file initially, output will be in yellow
# failed output in red

# the command module is used to run specific commands
ansible -m command -a "hostname" demo # will fetch hostname 

# the file module creates an empty file in specified directory
ansible -m file -a "path=/tmp/testfile.txt state=touch" demo

# the copy command copies file from one directory to another
ansible -m copy -a "src=/home/ansible/demo.txt dest=/tmp/" demo

# the user command creates/deletes a user
ansible -m user -a "name=rajkumar state=present" demo --become #the --become gives root permission to ansible
ansible -m user -a "name=rajkumar state=absent" demo --become # state=absent deletes a user

#####################################################################################
# YAML Syntax
#####################################################################################

# YAML/YML is known as an ain't markup language. This is a human readable format.
# The formats could be .yaml/.yml - both the formats are the same
# The YAML file is created when we want to run ansible codes in form of a playbook
# The inputs in a YAML file are written as "key:value" pairs.

# Examples of how to write in YAML Language
# Scalar value 
Name:'John' 
# List of multiple values
Fruit:
- 'apple'     # Fruit{0}
- 'banana'    # Fruit {1}
# Mapping dictionary/objects i.e. group of key:value pairs
Person:
 Name:'John' # Notice the indentation (give a space value to define parent & child pair)
 Age:24
# The comments in a YAML file are written after "#"

#####################################################################################
# Example Ansible Playbook
#####################################################################################

# In the MASTER node, create a new ansible playbook yml file
vi demo1.yml

# Enter the following playbook YAML file details in the file

--- # good practice to start playbook with 3 hyphens
- host: demo    # tells ansible what group of servers to use i.e. the Slave node IP
  become: true  # tells ansible to run script as an admin (sudo user)
  tasks:        # all tasks to be performed by ansiible go under this
  - name: Install nginx service # name of 1st task, in case we have multiple task
    yum:        # the module for the task
     name: nginx    # provide details to the module defined above
     state: present
  - name: Start the service # name of 1st task, in case we have multiple task
    service:        # the module for the task
     name: nginx    # provide details to the module defined above
     state: started    

 demo1.yml # Press [CTRL]+[c] and type :wq! to save and exit the editor

# running the playbook
ansible-playbook demo1.yml --syntax-check   # code to check for syntax error
ansible-playbook demo1.yml --check          # dry run or trial of the code on terminal and not the server
ansible-playbook demo1.yml                  # final run of playbook on the server

#####################################################################################
# Ansible Roles
#####################################################################################

# Ansible has another aspect called Ansible Roles.
# Ansible Roles are used for reusability purposes. Roles (like playbooks) can be created to reuse ansible codes.

# Creating a new role
sudo ansible-galaxy init /etc/ansible/roles/nginxrole 
# ansible-galaxy init {role-path-with-name}

# The above command will create a role, with a default folder structure
# Role can be accessed in ansible dir
cd /etc/ansible/roles
# We mainly focus in the tasks folder inside the role

# For the rest of the steps on operating playbooks, refer to word docs with assignment submissions