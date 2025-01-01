
# Detailed Kubernetes Notes

## 1. Introduction to Kubernetes

### What is Kubernetes?
- Kubernetes, often abbreviated as K8s, is an open-source platform for managing containerized applications across a cluster of machines.
- It provides tools for automating deployment, scaling, and managing containerized workloads.

### Why Kubernetes?
- Containers revolutionized software development with portability, consistency, and efficiency, but managing them at scale is complex.
- Kubernetes simplifies these challenges by offering features like load balancing, self-healing, and storage orchestration.

### Key Terminologies
- **Cluster**: A set of nodes used to run containerized applications.

- **Node**: A machine (virtual or physical) in the Kubernetes cluster.

- **Control Plane**: The collection of processes that manages the state of the cluster, the master node.

- **Workload**: The applications running in Kubernetes.

---

## 2. Kubernetes Architecture

A kubernetes cluster should have at least 3 nodes: 1 master and 2 nodes.

### Components of a Kubernetes Cluster
#### Master Node (Control Plane)
1. **Kube API Server**:
   - Acts as the communication hub for all Kubernetes components. It acts as the front-end for a kubernetes cluster. 
   - It is the only component that can communicate with any other component in the entire cluster. It handles all authentication and authorization tasks.
   - Validates and processes RESTful API requests.

2. **ETCD**:
   - It effectively acts as a database that stores all information regarding a kubernetes cluster e.g. how many microservices (pods) are running, confiurations etc. 
   - The data is stored in a distributed key-value format.
   - Ensures high availability and consistency.

3. **Scheduler**:
   - Assigns pods to nodes based on resource requirements and constraints.
   - It ensures that the resources for running applications are allocated efficiently, considering both resource availability and the requirements specified by the user.
   - Suppose you have a Kubernetes cluster with several nodes and pods that need certain resources (CPU and memory). When a pod is created, the Scheduler checks the available resources on each node, and if Node A has sufficient CPU and memory to run the pod, it will be scheduled there. If Node A runs out of resources, the Scheduler will look at other nodes (Node B, Node C) and place the pod accordingly.

4. **Controller Manager**:
   - Runs control loops to manage the cluster state (e.g., node lifecycle, endpoints, replication).
   - It runs a set of controllers that continuously monitor the state of the cluster and make adjustments to ensure that the cluster's actual state matches the desired state as defined by the user.

#### Worker Node
1. **Kubelet**:
   - Agent running on each node to ensure containers are running as expected.
   - It communicates with the Kubernetes API server and receives instructions (such as which pods should be running on the node). It ensures that the desired state defined by the Kubernetes control plane is achieved.

2. **Kube Proxy**:
   - The Kube Proxy is responsible for maintaining network rules on the worker node to ensure that communication between pods (both inside and outside of the cluster) works as expected.
   - It ensures that traffic to services is correctly routed to the appropriate pods, maintaining network connectivity and load balancing.

3. **Container Runtime**:
   - Software that holds pods which encapsulate containers, and also enables running of these containers (e.g., Crisocket, containerd, CRI-O, Docker).
   - It provides the necessary tools for pulling container images, starting and stopping containers, and managing their lifecycle. The container runtime interfaces with the underlying operating system to execute containers in a consistent, isolated environment.

---

## 3. Kubernetes Objects

### Pods
- The smallest and simplest Kubernetes object. A pod represents one or more containers that are tightly coupled and share the same network namespace and storage.
- Types:
  - **Single-container pod**: Runs one container per pod.
  - **Multi-container pod**: Containers in a pod share resources and communicate via localhost.

It is recommended that even though we have multiple containers in a pod, we should have the same application running in all containers in the pod e.g. nginx. There maybe cases when we might need to run a major application, and another minor application in the same pod. This is known as a **side car pod**, however, this is not recommended.

Note:<br>
- A **container** is the fundamental unit of application packaging and runtime, used to run individual services or applications.<br>
- A **pod** is a Kubernetes abstraction that can encapsulate one or more containers, providing shared storage, networking, and a cohesive management layer for these containers.

In Kubernetes, a pod is the smallest unit of deployment, not the container itself, because Kubernetes needs to manage networking, scaling, and orchestration across multiple containers effectively.

### Services
- A service is an abstraction that provides stable networking for a group of pods.
- Since pods are ephemeral and can have changing IPs, a service provides a consistent IP address (ClusterIP) and DNS name for accessing these pods.
- Services enable communication between pods, or between external users and pods.
- Types of Services:
  1. **ClusterIP**: 
     - Default type; accessible only within the cluster.

  2. **NodePort**: 
     - Exposes the service on a static port on each node. 
     - This is similar to the port forwarding concept in docker as it will allow you to expose the mode outside the cluster.

  3. **LoadBalancer**: 
     - Integrates with external load balancers for global accessibility, similar to the NodePort. 
     - The difference between this and NodePort comes if we are using an external load balancer. A load balancer's work is to balance the loads on pods by distribution/routing requests across different pods and autoscaling of pods. Kubernetes comes with an internal load balancer too. 
     - If we also have an external load balancer, this LoadBalancer service will create an external IP address, that will help communicate with the external load balancer to help with routing requests to pods.

  4. **ExternalName**: 
     - Maps a service to an external hostname i.e. assign a domain name like www.example.com to our port number 172.30.98.0

  5. **Headless Service**:
     - This is a type of service that allows clients to directly connect to individual pods without using a ClusterIP for load balancing or any other service.
     - This is useful when an application requires direct communication with any pods.

### Deployments
- A Deployment in Kubernetes is a high-level object that provides declarative updates for applications. It manages the lifecycle of Pods and ensures the desired number of replicas are running at any time. Deployments make it easy to scale, roll out, roll back, and self-heal applications in a Kubernetes cluster.
- Key Features:
   1. **Declarative Updates**:
       - Define the desired state in a YAML or JSON file, and Kubernetes ensures the cluster matches this state.

   2. **Rolling Updates**:
       - Incrementally update the application pods to the new version without downtime.

   3. **Rollback**:
       - Revert to a previous version if something goes wrong during an update.

   4. **Scaling**:
       - Scale the application up or down by increasing or decreasing the number of replicas.

   5. **Self-Healing**:
       - Automatically replace failed or unresponsive pods to maintain the desired state.

### ConfigMaps
- Used to store non-sensitive configuration data as key-value pairs.
- Example: Application configuration settings.

### Secrets
- Stores sensitive data like passwords, tokens, and keys securely.
- Supports Base64-encoded storage.

### Persistent Volumes (PV) and Persistent Volume Claims (PVC)
- **PV**: Represents storage resources in the cluster.
- **PVC**: A request for storage from a user.

---

## 4. Kubernetes Networking

Kubernetes networking enables communication between different components in a Kubernetes cluster, including pods, services, and external systems. The networking model in Kubernetes is designed to be flat, meaning all pods can communicate with each other without NAT (Network Address Translation), regardless of the node on which they are running.

### Key Concepts in Kubernetes Networking

1. **Pod-to-Pod Communication**:
   - Each pod in Kubernetes is assigned a unique IP address.
   - Pods can communicate directly with each other using these IPs, assuming no network policies block the communication.

2. **Pod-to-Service Communication**:
   - Services provide stable IPs and DNS names to access pods, even as pod IPs change dynamically due to scaling or restarts.

3. **Cluster-to-External Communication**:
   - Kubernetes allows external systems to interact with pods using services (e.g., LoadBalancer or NodePort).
   - Pods can also access external systems like databases or APIs.

4. **Network Plugins**:
   - Kubernetes itself doesn’t implement networking. Instead, it relies on third-party network plugins (CNI - Container Network Interface) to manage pod networking.
   - Examples: Flannel, Calico, Weave Net, and Cilium.

### Networking Components in Kubernetes

1. **Cluster Networking**
   - Facilitates communication between pods across nodes.
   - Managed by the **CNI plugin** that implements the Kubernetes networking model.

2. **Service Networking**
   - Provides stable endpoints for accessing groups of pods.
   - Types of services discussed above

3. **DNS**
   - Kubernetes automatically creates DNS records for each service.
   - Pods can resolve service names to ClusterIP addresses for communication.

4. **Ingress**
   - Manages external HTTP(S) traffic to services in the cluster.
   - Allows you to define rules for routing external requests to internal services.

<br>
Kubernetes networking is a critical component enabling communication between pods, services, and external systems. Its flat, pod-centric approach simplifies containerized application deployment while allowing advanced customizations through CNI plugins, network policies, and ingress controllers.

---

## 5. Kubernetes Storage

Kubernetes provides a flexible and scalable storage system to manage the persistent and temporary storage needs of containerized applications. Storage in Kubernetes allows data to persist beyond the lifecycle of individual pods and ensures data consistency and availability across the cluster.

### Key Concepts in Kubernetes Storage

1. **Volumes**:
   - A Kubernetes **Volume** is a directory accessible to all containers in a pod.
   - Volumes allow data sharing between containers in a pod and provide a way to persist data.

2. **Persistent Volumes (PVs)**:
   - A **Persistent Volume (PV)** is a piece of storage provisioned in the cluster, either statically by an administrator or dynamically by Kubernetes (local disk, cloud storage, networked storage).
   - It is independent of the pod lifecycle.

3. **Persistent Volume Claims (PVCs)**:
   - A **Persistent Volume Claim (PVC)** is a request by a user for storage.
   - Pods use PVCs to bind to PVs and consume storage.

4. **Storage Classes**:
   - A **StorageClass** defines the type of storage and its characteristics, such as performance, replication, and volume type.
   - Example storage backends: AWS EBS, Google Persistent Disk, Azure Disks, NFS, etc.

5. **Access Modes for Volume**:
     
      | **Access Mode**      | **Description**                                                                      |
      |-----------------------|-------------------------------------------------------------------------------------|
      | **ReadWriteOnce (RWO)** | Volume can be mounted as read-write by a single node at the same time.                             |
      | **ReadOnlyMany (ROX)**  | Volume can be mounted as read-only by many nodes at the same time.                                 |
      | **ReadWriteMany (RWX)** | Volume can be mounted as read-write by many nodes at the same time.                                |

6. **Reclaim Policies**:
     - The reclaim policy determines what happens to a PV when it is released (e.g., PVC deleted):
       - **Retain**: Retains the PV for manual cleanup.
       - **Delete**: Deletes the PV and its data.
       - **Recycle**: Clears the volume for reuse (deprecated in most cases).

7. **Dynamic Volume Provisioning**:
   - Allows Kubernetes to automatically create and delete PVs based on PVC requests, eliminating the need for pre-provisioned storage.

8. **Ephemeral Storage**:
   - Temporary storage that exists only for the lifetime of a pod.
   - Types: `emptyDir`, `configMap`, `secret`.

### Types of Kubernetes Volumes

| **Volume Type**             | **Description**                                                                 |
|------------------------------|---------------------------------------------------------------------------------|
| **emptyDir**                 | Temporary storage that is deleted when the pod is removed.                     |
| **hostPath**                 | Mounts a file or directory from the host node into a pod.                      |
| **nfs**                      | Mounts an NFS share for shared storage across pods.                            |
| **persistentVolumeClaim**    | Attaches a Persistent Volume to a pod using a PVC.                             |
| **configMap**                | Provides configuration data as files or environment variables inside a pod.    |
| **secret**                   | Mounts sensitive data, such as passwords or tokens, into pods.                |
| **awsElasticBlockStore**     | Integrates with AWS EBS for durable block storage.                             |
| **azureDisk**                | Integrates with Azure Disks for block storage.                                 |
| **csi**                      | Uses Container Storage Interface (CSI) drivers for storage plugins.           |

<br>
With its robust volume and persistent storage mechanisms, Kubernetes ensures applications have access to reliable, scalable, and dynamic storage. By combining Persistent Volumes, Persistent Volume Claims, and Storage Classes, Kubernetes abstracts the complexity of storage management, allowing developers to focus on application logic.

---

## 6. Monitoring and Logging

### Tools for Monitoring
- **Prometheus**: Popular monitoring system for Kubernetes.
- **Grafana**: Visualization and dashboarding tool.
- **Kubernetes Dashboard**: UI to monitor cluster health.

### Logging Tools
- **Fluentd**: Aggregates logs from nodes and containers.
- **Elasticsearch**: Log storage and indexing.
- **Kibana**: Log visualization.

---

## 7. Security in Kubernetes

### Best Practices
1. Use **Namespaces** to isolate workloads.
2. Restrict pod privileges with **Pod Security Policies**.
3. Secure sensitive data using **Secrets**.
4. Monitor cluster activity for threats using tools like **Falco**.

---

## 8. Helm in Kubernetes

Helm is a popular package manager for Kubernetes. It simplifies the deployment and management of Kubernetes applications by using pre-configured application templates called Helm Charts. Helm enables developers and operators to package, configure, and deploy applications consistently and easily.

### Why Use Helm?

- **Simplifies Deployment**: Automates the process of deploying complex Kubernetes applications.

- **Version Control**: Helm maintains a history of deployed releases, enabling easy rollbacks to previous versions.

- **Reuse and Share Templates**: Use existing Helm Charts or share custom ones.

- **Centralized Configuration**: Manage application configuration via values files, reducing manual edits in YAML files.

- **Eases CI/CD Integration**: Integrate Helm into pipelines to deploy applications automatically.

### Key Concepts in Helm

1. **Chart**: A Helm Chart is a collection of files that describe a Kubernetes application. It contains templates for Kubernetes manifests, a default configuration file (`values.yaml`), and metadata about the chart.
   
2. **Release**: A release is a specific instance of a Helm Chart deployed in a Kubernetes cluster.

3. **Repositories**: A Helm repository is a collection of Helm Charts stored in a remote location (like GitHub, Artifact Hub).

4. **Values**: Values are configuration parameters passed to Helm Charts to customize deployments.

### Helm Chart Components

| **File**            | **Purpose**                                                                                     |
|---------------------|-------------------------------------------------------------------------------------------------|
| `Chart.yaml`        | Metadata about the chart (name, version, description, etc.).                                    |
| `values.yaml`       | Default configuration values for the chart.                                                    |
| `templates/`        | Directory containing Kubernetes manifest templates (e.g., `deployment.yaml`, `service.yaml`).   |
| `README.md`         | Documentation about the chart.                                                                 |
| `requirements.yaml` | Lists dependencies for the chart (optional, used for nested charts).                           |

### How Helm Charts Work

1. **Create**: Developers create a chart with all necessary Kubernetes resources (Deployment, Service, ConfigMap, etc.).

2. **Package**: The chart is packaged and shared via a repository.

3. **Install**: Users install the chart using `helm install`. Helm templates are rendered into Kubernetes manifests using the provided values and then applied to the cluster.

4. **Upgrade**: Use `helm upgrade` to update the application with new configurations or versions.

5. **Rollback**: Use `helm rollback` to revert to a previous release if an upgrade fails.

### Helm Hub
- Helm Hub (now part of Artifact Hub) is a central repository for publicly shared Helm Charts.
- Provides pre-built charts for popular applications like WordPress, Jenkins, MongoDB, MySQL, etc.


Helm is a powerful tool for managing Kubernetes applications. By using Helm Charts, teams can standardize deployments, reduce errors, and improve collaboration.

---

## 9. Kubernetes Deployment Methods

| **Category**                    | **Tool**                       | **Description**                                                                                                                                      | **Supported Platforms**       | **Use Case**                                                                                      |
|----------------------------------|--------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------|-------------------------------|--------------------------------------------------------------------------------------------------|
| **Local Development Tools**      | **Minikube**                   | Creates a local single-node Kubernetes cluster in a VM or container.                                                                                | Linux, macOS, Windows          | Local development, testing, learning Kubernetes.                                                  |
|                                  | **K3s**                        | Lightweight Kubernetes for resource-constrained environments (e.g., IoT, edge computing).                                                          | Linux, macOS, Windows (WSL)    | Local development on low-resource environments.                                                  |
|                                  | **Kind**                       | Runs Kubernetes clusters in Docker containers, ideal for local testing and CI/CD environments.                                                      | Linux, macOS, Windows (WSL2)   | Local multi-node testing, CI/CD environments.                                                     |
|                                  | **Docker Desktop**             | Kubernetes integrated with Docker Desktop for macOS/Windows.                                                                                       | macOS, Windows                 | Simple local Kubernetes for developers using Docker.                                              |
| **Cloud Managed Services**       | **GKE (Google Kubernetes Engine)** | Fully managed Kubernetes service by Google Cloud, abstracts infrastructure management.                                                              | Google Cloud                   | Production-grade Kubernetes with minimal overhead.                                               |
|                                  | **EKS (Elastic Kubernetes Service)** | Managed Kubernetes service by AWS, integrates with AWS ecosystem.                                                                                  | AWS                           | Managed Kubernetes on AWS infrastructure.                                                        |
|                                  | **AKS (Azure Kubernetes Service)** | Managed Kubernetes by Microsoft Azure, integrates with Azure services.                                                                              | Azure Cloud                   | Managed Kubernetes in Azure, integrates with Azure tools.                                         |
|                                  | **IBM Cloud Kubernetes Service** | Managed Kubernetes service by IBM Cloud.                                                                                                            | IBM Cloud                     | Kubernetes on IBM Cloud, good for enterprises using IBM services.                                |
|                                  | **DigitalOcean Kubernetes (DOKS)** | Managed Kubernetes offering by DigitalOcean for simpler, cost-effective Kubernetes clusters.                                                       | DigitalOcean Cloud             | Cost-effective Kubernetes for small to medium-sized teams.                                        |
| **On-Premise Solutions**         | **Kubespray**                  | Kubernetes deployment tool for on-premise or private cloud infrastructure using Ansible.                                                            | Linux (VMs, bare-metal)        | Deploy Kubernetes clusters on-premise or on private clouds.                                      |
|                                  | **Rancher**                    | Multi-cluster Kubernetes management tool that supports on-premise and cloud clusters.                                                              | Linux, macOS, Windows          | Centralized Kubernetes management across on-prem and cloud environments.                         |
| **Cluster Management Tools**     | **kOps**                       | Tool for creating and managing production-grade Kubernetes clusters on cloud platforms.                                                            | AWS, GCP, others               | Cluster creation and management for production.                                                  |
|                                  | **Kubeadm**                  | A tool for bootstrapping Kubernetes clusters, simplifying the deployment of control plane and worker nodes.                                                        | Linux, macOS, AWS, GCP, others        | Used for initializing and managing Kubernetes clusters, including setup of master and worker nodes.                        |
|                                  | **Terraform**                  | Infrastructure-as-code tool that can automate Kubernetes cluster provisioning and management.                                                        | AWS, Azure, GCP, on-prem       | Infrastructure automation and multi-cloud support for Kubernetes clusters.                        |
|                                  | **Helm**                       | Kubernetes package manager that simplifies deploying applications and clusters using Helm charts.                                                  | Any Kubernetes cluster         | Managing complex Kubernetes applications using charts.                                           |

---

## 10. Kubernetes vs. Docker (Benefits of Kubernetes)

Kubernetes and Docker are two essential technologies in modern containerized application development and deployment. However, they serve different purposes and are not direct competitors.

| **Aspect**                | **Kubernetes**                                                                                             | **Docker**                                                                                           |
|---------------------------|-----------------------------------------------------------------------------------------------------------|------------------------------------------------------------------------------------------------------|
| **Definition**            | Kubernetes is an orchestration platform for managing containers at scale, automating deployment, scaling, and operations. | Docker is a containerization platform that allows developers to build, ship, and run applications in containers. |
| **Role**            | Manages containerized applications across multiple hosts, providing high availability and scalability. | Focuses on creating and running containers on a single host. |
| **Primary Goal**          | To manage, schedule, and orchestrate containers efficiently across a cluster of machines.                 | To package and run applications in isolated environments (containers).                              |
| **Cluster Management**    | Supports managing containers across multiple nodes in a cluster.                                          | Docker Swarm provides basic cluster management, but Docker itself operates on a single host.        |
| **Architecture**          | Includes Master Node (API server, scheduler, controller manager, etc.) and Worker Nodes (kubelet, kube-proxy). | Runs Docker Engine on a single host, managing containers locally.                                   |
| **Container Runtime**     | Supports multiple runtimes (e.g., Docker, containerd, CRI-O).                                             | Uses its own runtime, Docker Engine.                                                                |
| **Scaling**               | Automatically scales containers horizontally based on resource usage or custom metrics.                  | Requires manual scaling (or Docker Swarm for basic scaling).                                        |
| **Cluster Size**          | Built for large-scale distributed systems, managing thousands of containers.                             | Primarily designed for local development or small-scale deployments.                                |
| **Service Discovery**     | Built-in service discovery and load balancing via Services.                                              | Uses container DNS and user-defined networking but lacks advanced service discovery features.       |
| **Declarative Approach**  | Uses YAML manifests to declare the desired state of the cluster (e.g., number of replicas, services).     | Docker Compose provides declarative multi-container deployments, but it’s less powerful.            |
| **Self-Healing**          | Automatically restarts failed containers and maintains the desired state.                               | Does not provide self-healing; requires manual intervention.                                        |
| **Use Case: Development** | Supports development environments but has a more complex setup.                                         | Excellent for local development and testing on a developer’s machine.                               |
| **Complementary Nature**  | Often used to orchestrate Docker containers in production.                                              | Primarily used for building and running containers, then combined with Kubernetes for orchestration.|
| **Small Projects**        | Overkill for simple projects.                                                                          | Ideal for small-scale applications or local development.                                            |
| **Large-Scale Deployment**| Essential for managing, scaling, and automating containerized applications in production.               | Limited to Docker Swarm or other orchestration tools for scaling.                                   |

---

## 11. Summary of how Kubernetes runs an application

### 1. Pods and ReplicaSet
- **Pods**: The smallest deployable units in Kubernetes, running containers. In case you want to deploy a docker container, you can pass the docker image to a deployment file which in turn will create a pod that will be used to run the conatiner.
- **ReplicaSet**: Ensures a specific number of replicas of a pod are running at all times. A **Deployment** manages the ReplicaSet, ensuring the desired number of pods i.e. the number of replicas required are defined in the deployment file.

### 2. Role of Master and Worker Nodes
- **Master Node**: Manages the cluster's control plane, including components like the API server, scheduler, and etcd. It does **not** run application pods by default but coordinates pod placement and ensures the system is functioning.
- **Worker Nodes**: Run the actual **application pods** and containers. These nodes execute workloads that the master node schedules.

### 3. Pod Scheduling
- When you create a ReplicaSet or Deployment, the **Kubernetes scheduler** on the master node determines which **worker nodes** should run the pods based on available resources, affinity rules, and other factors.
- The **replicas** are distributed across the worker nodes for **high availability** and **fault tolerance**.

### 4. Scaling and Distribution
- Kubernetes ensures the requested number of replicas (e.g., 3) are running across available worker nodes. If a pod fails or a node goes down, Kubernetes automatically reschedules the pod to another available worker node.
- You can control pod placement with **affinity**, **anti-affinity**, **node selectors**, and **taints/tolerations**.

### 5. Fault Tolerance and Load Balancing
- Spreading replicas across worker nodes ensures **fault tolerance**—if one node fails, other replicas continue running on different nodes.
- Kubernetes provides **load balancing** to distribute traffic across multiple replicas.

### 6. Self-Healing
- Kubernetes ensures that the desired number of replicas is always maintained. If a pod crashes, it is automatically replaced by the ReplicaSet.

