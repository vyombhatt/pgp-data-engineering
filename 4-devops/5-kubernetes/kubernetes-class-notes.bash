#####################################################################################
# Creating a kubernetes cluster using EC2  
#####################################################################################

# Connect to an EC2 server

# Create 2 ec2 instances (1 Master, 1 Slave)
# For kubernetes, we need to use t2medium, which is chargeable
# The storage should be minimum 20GB

# Make sure all ports in all the instances are updated (like we did for jenkins)
# Go to the EC2 instance details -> Security -> Click on Security Group
# Click Edit Inbound Rules -> Add Rule
# [All Traffic, 8080, AnywhereIPv4]
# Save Rule

# Execute the below script in both the master and slave servers
sudo vi kubernetes.sh
# Copy and paste the content in the kubernetes.sh file and save it

sudo chmod +x kubernetes.sh # make the kubernetes.sh file an executable by giving it permission
./kubernetes.sh # executing the kubernetes.sh file

# Repeat the above commands in slave machine too

# Now we start creating the kubernetes cluster only in the master
sudo kubeadm init --pod-network-cidr=192.168.0.0/16 --apiserver-advertise-address=172.31.9.106 --cri-socket unix:///var/run/cri-dockerd.sock
# sudo kubeadm init - initializes kubernetes control plane on this machine, making it the master node 
# --pod-network-cidr=192.168.0.0/10 - Specifies the CIDR (Classless Inter-Domain Routing) range for the pod network
    # The pod network allows communication between pods within the cluster.
    # This range must match the requirements of the network plugin (e.g., Calico, Flannel, or WeaveNet) you plan to use.
    # Here, 192.168.0.0/10 allocates IP addresses for pods within the range, and we're using Calico plugin.
    # The other plugins will have a different CIDR range
# --apiserver-advertise-address={master-private-ip-address} -  Specifies the IP address on which the Kubernetes API server will advertise itself
# --cri-socket unix:///var/run/cri-dockerd.sock - Specifies the socket file for the container runtime interface (CRI) to use with the cluster
    # Kubernetes uses a container runtime (e.g., Docker, containerd, or CRI-O) to manage containers.
    # unix:///var/run/cri-dockerd.sock is the socket file for Docker when using cri-dockerd (a CRI shim for Docker, as Docker is not natively compatible with Kubernetes since version 1.20).

# On executing this command, we will get an output that will have the below command in the last line.
# Run that line in the slave node, this command can be used to join as many worker nodes to the master as required
sudo kubeadm join 172.31.46.136:6443 --token zosaya.qyjr52z1sozr98vu \
    --discovery-token-ca-cert-hash sha256:efb479447ded2971730468cba9ae8de0af204fc7e471b513e33b7387de80d004 \
    --cri-socket unix:///var/run/cri-dockerd.sock # this socket option needs to be added, same as the master

sudo kubeadm join 172.31.34.62:6443 --token 9lgeqo.yeiqjaoy8hgi2mdn \
        --discovery-token-ca-cert-hash sha256:11bb8e8168f8d1f060a9d1d74ab532515079fec2e7a1c448d33d2369db8224b4 --cri-socket unix:///var/run/cri-dockerd.sock

# sudo kubeadm join - join command connects a node to an existing kubernetes cluster
# 172.31.46.136:6443 - Specifies the IP address (172.31.46.136) and port (default is 6443) of the API server on the control plane node
# --token zosaya.qyjr52z1sozr98vu - Provides a bootstrap token used for authenticating the new node with the cluster.
# --discovery-token-ca-cert-hash sha256:efb479447ded2971730468cba9ae8de0af204fc7e471b513e33b7387de80d004 \
    # Ensures secure communication by validating the API server’s certificate during the join process.
# --cri-socket unix:///var/run/cri-dockerd.sock # Specifies the CRI socket that the new node will use for managing containers.


# In the Master Node
# To interact with a node in kubernetes, we use the kubectl command line

# the admin.conf file in /etc/kubernetes has the config details for all users
# in docker, we used getent to create a docker group so all users can access docker
# similarly, we need to add all worker nodes in admin.conf so that they can use kubectl commands

cd ~
mkdir -p $HOME/.kube # creates empty directory .kube
ls -al

sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config # copies admin.conf into a new file config in new location
sudo chown $(id -u):$(id -g) $HOME/.kube/config # provides permission to the config file 

# Now you will be allowed to run kubectl
kubectl get nodes # lists all nodes in cluster

# Now we need to configure the Calico network tool - these commands are available on https://docs.tigera.io/calico/latest/getting-started/kubernetes/self-managed-onprem/onpremises

# Install the operator
kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.29.1/manifests/tigera-operator.yaml

# Download the custom resources to configure Calico
curl https://raw.githubusercontent.com/projectcalico/calico/v3.29.1/manifests/custom-resources.yaml -O

# Create the manifest to install Calico
kubectl create -f custom-resources.yaml

kubectl get nodes # Now we see that the nodes are in ready status
kubectl get nodes -o wide

kubectl cluster-info # information about the cluster

kubectl get componentstatuses # provides the health of the major components of the cluster


#####################################################################################
# Working with Pods and Namespaces
#####################################################################################

# Creating a pod in Master - however, the pod will get deployed in the worker node only
kubectl run mydemopod --image=nginx
# similar to docker, it will look for this image in local, if it doesn't find it, then it will download from dockerhub

kubectl get pods # get details of the pods
kubectl get pods -o wide # extra details about pods

# All services in kubernetes (including api-servers) run in pods. Kubernetes uses namespaces to segregate pods of different kinds.
# By default, a default namespace is created when we create the cluster
kubectl get ns # lists all namespaces created

kubectl get pods # will fetch namespaces only from the default namespace
kubectl get pods -n kube-system # fetches pods in the kube-system namespace
    # kube-system contains system-level pods and services created by Kubernetes (e.g., DNS, API server).

kubectl logs mydemopod # generates logs for a pod
kubectl describe pod mydemopod # inspects the pod and gives details

# Enter a pod
kubectl exec -it mydemopod -- bash

exit # or ctrl+c, this will not stop the pod, it will only take you out of the pod

# Delete a pod
kubectl delete pod mydemopod


# Creating a pod in a new namespace

kubectl create ns devops # creating a new namespace
kubectl get ns
kubectl run mydemopod2 --image=nginx -n devops # creates pod in devops namespace
kubectl get pods -n devops # show all pods in devops namespace

# Delete a namespace, this will delete all pods and services inside the namespace
kubectl delete ns devops

# Command that tells us all resources available in the cluster
kubectl api-resources

# Labels
# We can assign a label to pods or services so that they can be tagged together
kubectl label pod mydemopod env=prod # adding the label `env=prod` to mydemopod, the label is a key-value pair
kubectl get pods --show-labels
kubectl label pod mydemopod env- # deleting a label, we pass the key of the label in this command


#####################################################################################
# Manifestation files
#####################################################################################

# Important components of a manifestation file:
    # apiVersion - eg. v1 
    # kind - type of resource: service, pod. get all resources using `kubectl api-resources`
    # metadata - key-value pairs to assign metadata e.g. name : mydemopod
    # spec - provide all specifications of the containers

# Create a manifestation file with in Master node with any name
sudo vi mydemonginxpod.yml

# Paste below content into the file
apiVersion: v1
kind: Pod # another e.g. Deployment
metadata:
  name: mydemopod1
  labels:
    app: mydemopod1
spec:
  containers:
  - name: mydemocontainer
    image: nginx
    ports:
    - containerPort: 80

# Save and exit the file

# Executing the manifestation file
kubectl apply -f mydemonginxpod.yml
kubectl create -f mydemonginxpod.yml
# either of the 2 commands can be used, apply is preferred as it is more advanced in functionality

kubectl get pods
kubectl get pods --show-labels

#####################################################################################
# Services in Kubernetes
#####################################################################################

kubectl get services # shows all services

# Create a manifestation file with in Master node with any name
sudo vi mydeployment.yml

# Paste below content into the file
apiVersion: v1
kind: Deployment
metadata:
  name: mydeploy # name of deployment
    # for kind: Deployment, we don't provide label here like pods
spec:
  replicas: 3 # Since we chose kind: Deployment, replicas will define number of pods 
  selector: # the selector acts as a filter to choose which pods to build from all that are provided in the template
    matchLabels:
      app: mydemoapp # This is where we define the label, the selector will match this label with all labels in template for selecting
  template:
    metadata:
      labels:
        app: mydemoapp # This label will have to match the label above so that selector can match this
    spec:
      containers: # all the containers information will be present here
      - name: mydemocontainer
        image: nginx
        
# Running the manifestation file
kubectl apply -f mydeployment.yml

kubectl get deployments # fetches details of all deployments
kubectl get pods

# Roll out a deployment - If we want to change the image of all pods in a deployment
kubectl set image deployment/mydeploy mydemocontainer=httpd # changing from nginx to httpd
# kubectl set image deployment/{deployment-name} (deployment-container-name)=(application)
kubectl get deployment -o wide

# Rolling back the deployment to previous state
kubectl rollout undo deployment/mydeploy 

kubectl rollout history deployment/mydeploy # this will show all rollouts along with their revision numbers

kubectl rollout undo deployment/mydeploy --to-revision=2 # we can roll back to a specific revision number


# Adding a service to the manifestation file
sudo vi mydeployment.yml
# Refer to the mydeployment.yml file for the implementation of a service in the manifestation file

kubectl apply -f mydeployment.yml # running the manifestation file
kubectl get services # checking if the service is running
# In the service, you will see the port exposed as 80:31329/TCP i.e. {target-port}:{random-port-opened}/TCP
# you can access this port on a browser through {machine-public-ip}:{random-port-opened}
curl ifconfig.me # get the public ip and check if service is running through the target port

# Deleting a service
kubectl delete service mydemoservice

#####################################################################################
# Storage in Kubernetes
#####################################################################################

# Creating a Persistent Volume
sudo vi mydemovolume.yml # creating a new manifestation file
# Refer to the mydemovolume.yml file for implementation of Persistent Volume in the manifestation file
kubectl apply -f mydemovolume.yml # running the manifestation file

kubectl get pv # fetch info about all persistent volumes

# Creating a Persistent Volume Claim
sudo vi mydemoclaim.yml # creating a new manifestation file
# Refer to the mydemoclaim.yml file for implementation of Persistent Volume in the manifestation file
kubectl apply -f mydemoclaim.yml # running the manifestation file
kubectl get pvc # fetch info about all persistent volume claims 

kubectl get pv # After adding claim to the volume, check the status (it should be 'Bound')

# After creating the PV and PVC, we go back to our manifestation file and assign the volume to the deployment code
# Refer to mydeployment.yml lines 19-25

kubectl apply -f mydeployment.yml # running the manifestation file

kubectl get deployment
kubectl describe deployment mydeploy # we will now see the Claim has been established for the pods

# Commands to delete PV or PVC
kubectl delete pv {pv-name}
kubectl delete pvc {pvc-name}

#####################################################################################
# Helm Charts
#####################################################################################

# First we need to install helm - https://helm.sh/docs/intro/install/

# Download and install helm
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3

# Provide necessary permissions
chmod 700 get_helm.sh

# Execute the script
./get_helm.sh

# Check if helm is running
helm # should give an output


## Installing a helm chart from a repository

# We will use the bitnami repository: https://bitnami.com/stacks/helm
# Adding the bitnami repository
helm repo add bitnami https://charts.bitnami.com/bitnami

helm search repo bitnami # this will show all the charts available in the repo. All charts are in form of .tar files
helm search repo bitnami | grep -i nginx # looking for a specific chart

# inspecting the items in a helm chart
helm pull --untar bitnami/nginx # this command will download and unzip the charts from the repository

cd nginx
ls -al #all unzipped files will be accessible here

# this command will install the helm chart and the resources as defined in the different files in the helm chart
helm install mydemohelm bitnami/nginx
# helm install {give-random-helm-name} {repo}/{chart}

# In case we want to modify any of the default resources
# Say we want to modify replicaCount resource in the values.yml file of the helm chart
# Create a new empty file in our working dir
sudo vi demohelm.yml
# Just enter this one line in the file
# replicaCount: 3
# Then create the resources with these modifications
helm install mydemohelm bitnami/nginx -f demohelm.yml

helm list # shows details of all helm charts installed
kubectl get pods # the defined pods in the helm chart will have been created

helm uninstall mydemohelm # this will uninstall the helm chart, and remove all resources created by it too
