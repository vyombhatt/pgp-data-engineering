#####################################################################################
# Creating a docker instance in EC2 
#####################################################################################

# Connect to an EC2 server

# Install docker on ec2
sudo yum install -y docker

# need to enable the docker service, like we did with jenkins also
sudo systemctl enable docker
sudo systemctl start docker

systemctl status docker # check status of docker

# docker will by default be installed in the root directory
cd /var/lib/docker # this is the root dir

# to access this directory, we need to be a root user
sudo su # switch to root user
cd /var/lib/docker
ls -al
exit # come out of the root directory

# Since docker is currently in root dir, only root users can access it
# Instead we will great a docker group so that non root users can also access it
getent group docker # see if any docker group exists

sudo usermod -aG docker $USER # attaching a user to a docker group
# usermod -> command for adding to group, -aG -> attach Group, $USER -> env var that has curren user
newgrp docker # activates the group with new user
getent group docker # check is user is attached

sudo docker run hello-world # run hello-world image, this is a test image from docker
# having done the above step, we no longer need sudo to run docker


## Running Docker
# Docker can be run using different modes
# 1. running in detach mode - the docker runs in background and we don't log into it
docker run -itd --name mydockercontainer nginx
docker run -d --name mydockercontainer nginx # both commands can be used for detach mode
# the above command, docker will look for image nginx in local, otherwise download from docker hub

docker images # list all images downloaded
docker ps # lists all containers that are currently running

# 2. running in foreground mode
docker attach cc8508bb5c6 # docker attach {container_id}
docker attach quirky_ritchie # docker attach {container_name}
# we get the container id and name from docker ps command
# foreground mode logs into a detached container and allows you to access it through terminal

docker ps -a # lists all containers even if they are not running
docker start {container_id} # this will start an inactive container
docker stop {container_id} # this will stop a container
docker restart {container_id} # this will restart a container
docker rm {container_id} # deletes a container

docker rmi {image_name} # deletes a docker image
# make sure no container is using the image before deleting an image

# 3. running in interactive terminal
docker run -it --name demonginx nginx
# this will create the container and log into it

# press CTRL+P+Q to move out of the container without closing conntainer

# to get into an existing container in interactive mode
docker exec -it {container_id} /bin/bash

docker logs {container_id} # lists logs of a container
docker inspect {container_id} # gives additional details about a container


## Exposing docker containers
# There are 2 main methods of exposing your docker contiainer to others
# 1. Port forwarding (denoted by -P)
# Docker has a default range of limited ports numbers that we can use for forwarding
# 2. Binding port (denoted by -p)
# We use this when we want to choose a port number outside the range e.g. 80, 8080

# Docker containers are recommeded to be exposed before creating the container

docker run -d -P nginx # creates a docker container with Port forwarding
# Since we have not specified a port number, it will automatically assign port in the range

# On ec2, if we want to access the port outside the machine:
# AWS Concole -> EC2 Instance -> Security -> Click on Security Group
# Edit Inbound Rules -> Add Rule
# Set ["All Traffic"] [0.0.0.0/0] (this opens all ports to the internet) -> Save

# Get public IP of ec2 instance
curl ifconfig.me
# Go to browser and enter {ec2 public}:{docker port forwarded number}
# E.g 65.0.110.1:32768

docker run -d -p 8001:80 # creates a docker container with Binding port
# {binding port}:{container port number}
# the container port number depends on the service running on docker e.g. 80 for nginx
# In the browser, enter {ec2 public}:{binding port} e.g. 65.0.110.1:8001


## Volumes
# Volume mounting in refers to attaching storage (called volumes) to a Docker container 
# so that data can be shared between the container and the host. 
# This is like creating a backup of the data in a container so it is not lost if container is deleted
# denoted by -v

docker volume create mydemovol # creating a volumne, creates in /var/lib/docker/mydemovol
docker volume ls # lists all volumes
docker volume inspect mydevvol # lists additional info about volume

docker run -d -v mydemovol:/tmp nginx # creates docker container with volume mounted
# all the stored data in mydevvol volume gets copied to /tmp folder in container

docker ps # lists all active containers
docker exec -it (container_id) # enter the container
ls -al # check all the files in the container

