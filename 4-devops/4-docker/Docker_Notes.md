
# Docker Notes

## What is Docker?
Docker is an **open-source platform** designed to automate the deployment, scaling, and management of applications using **containerization**. It packages applications with all their dependencies into lightweight, portable containers that run consistently across different environments.

---

## Key Features of Docker
1. **Containerization**:
   - Containerization in Docker refers to the process of packaging an application, along with all its dependencies (libraries, frameworks, configuration files, etc.), into a lightweight and portable unit called a container. 
   - These containers can run consistently across various environments, from a developer's local machine to staging and production systems, regardless of underlying differences in infrastructure.
2. **Lightweight**:
   - Containers share the host system's kernel, making them faster and smaller than virtual machines.
3. **Portability**:
   - Containers can run on any system with Docker installed.
4. **Isolation**:
   - Each container runs in its own isolated environment.
5. **Scalability**:
   - Containers can be easily scaled up or down.

---

## Components of Docker
1. **Docker Engine**:
   - The core runtime that builds, runs, and manages containers.
2. **Docker Images**:
   - Immutable templates or blue prints for containers. Includes the OS, application code, and dependencies.
3. **Docker Containers**:
   - Running instances of Docker images. Containers are isolated but lightweight.
   - When an image is run, Docker creates a container from that image.
4. **Docker Hub**:
   - A cloud-based registry for sharing and storing Docker images.
5. **Docker Compose**:
   - A tool to define and manage multi-container applications using a YAML file (`docker-compose.yml`).

---

## Benefits of Docker
1. **Faster Deployment**:
   - Containers start in seconds compared to minutes for virtual machines.
2. **Consistency**:
   - Eliminates the "works on my machine" issue.
3. **Resource Efficiency**:
   - Containers use fewer system resources than virtual machines.
4. **Integration**:
   - Works seamlessly with CI/CD pipelines for continuous integration and delivery.

---

## Docker vs Virtual Machines
| **Feature**        | **Docker Containers**              | **Virtual Machines**            |
|---------------------|------------------------------------|----------------------------------|
| **Size**           | Lightweight (MBs)                 | Heavy (GBs)                     |
| **Startup Time**   | Seconds                           | Minutes                         |
| **Isolation**      | Process-level                     | Full OS-level                   |
| **Portability**    | High                              | Limited                         |
| **Performance**    | Near-native                       | Overhead due to hypervisor      |

---

## Docker Workflow
1. **Build**:
   - Create a Docker image from a `Dockerfile`.
2. **Run**:
   - Start a container from the built image.
3. **Test**:
   - Verify the application within the container.
4. **Deploy**:
   - Push the image to a registry (e.g., Docker Hub) and deploy it in production.

---

## Basic Docker Commands

### 1. Docker Installation Check
```bash
docker --version
```

### 2. Run a Test Container
```bash
docker run hello-world
```

### 3. Pull an Image
```bash
docker pull <image_name>
```

### 4. List Images
```bash
docker images
```

### 5. Build an Image
```bash
docker build -t <image_name> .
```

### 6. Run a Container
```bash
docker run -d -p 80:80 <image_name>
```

### 7. Stop a Container
```bash
docker stop <container_id>
```

### 8. Remove a Container
```bash
docker rm <container_id>
```

### 9. Remove an Image
```bash
docker rmi <image_name>
```

### 10. List Running Containers
```bash
docker ps
```

### 11. List All Containers (including stopped ones)
```bash
docker ps -a
```

---

## Dockerfile Example
A `Dockerfile` is a text document with instructions to create a Docker image.

```dockerfile
# Use an official Python runtime as a base image
FROM python:3.9-slim

# Set the working directory in the container
WORKDIR /app

# Copy the current directory contents into the container
COPY . /app

# Install any dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Make port 80 available to the world outside this container
EXPOSE 80

# Define the command to run the application
CMD ["python", "app.py"]
```

---

## Using Docker Compose
Docker Compose is a tool for defining and running multi-container Docker applications.

### `docker-compose.yml` Example
```yaml
version: '3.8'
services:
  web:
    image: nginx:latest
    ports:
      - "8080:80"
  app:
    build:
      context: .
    ports:
      - "5000:5000"
```

### Docker Compose Commands
1. **Start Services**:
   ```bash
   docker-compose up
   ```
2. **Stop Services**:
   ```bash
   docker-compose down
   ```

---

## Common Use Cases
1. **Application Development**:
   - Provides consistent environments for development, testing, and production.
2. **Microservices**:
   - Containers are ideal for deploying microservices due to their lightweight nature.
3. **CI/CD Pipelines**:
   - Simplifies integration and delivery workflows.
4. **Scaling Applications**:
   - Containers can be replicated to meet increasing demand.

---

## Volume Mounting in Docker
Volume mounting in Docker refers to attaching storage (called **volumes**) to a Docker container so that data can be shared between the container and the host or persist beyond the lifecycle of the container. This is a key feature for managing stateful applications in Docker.

---

## Docker Networks

Docker provides several types of networks that you can use to manage communication between containers and the outside world. Each network type serves different purposes, allowing flexibility in how containers connect and communicate.

---

### 1. Bridge Network (Default)

- **Description**:  
  The default network for containers when no specific network is specified. Containers on the same bridge network can communicate with each other using their container names as hostnames.
- **Use Case**:  
  Suitable for standalone containers needing simple container-to-container communication on the same host.

- **Key Points**:
  - Docker creates a `bridge` network named `bridge` by default.
  - Containers on the bridge network cannot connect to external networks without explicit port forwarding.

- **Command to List Bridge Networks**:
  ```bash
  docker network ls 
  ```

### 2. Host Network

- **Description**:
   Shares the host's networking stack with the container. The container does not get its own IP address; it uses the host's IP and ports.

- **Use Case**:
   Useful when performance is critical, and containerized applications need direct access to the host network. Ideal for applications where you don't want network isolation.

- **Key Points**:

   - No port mapping is required because the container uses the host's ports.
   - No isolation between the container and the host network.

- **Example Command**:

   ```bash
   docker run --network host <image>
   ```

### 3. None Network

- **Description**:
   The container has no network interface other than a loopback device.

- **Use Case**:
   Useful for security-focused setups where network access is not required.

- **Key Points**:

   - No communication with other containers or external networks.
   - Only a local loopback interface (127.0.0.1) is available.

- **Example Command**:

   ```bash
   docker run --network none <image>
   ```

### Summary of all Docker Networks Types


| **Network Type** | **Description**                     | **Use Case**                                  |
|-------------------|-------------------------------------|-----------------------------------------------|
| **Bridge**        | Default network, isolated.         | Standalone containers on the same host.       |
| **Host**          | Uses host’s network stack.         | Performance-critical applications.           |
| **None**          | No network, only loopback.         | Highly secure, no external access.           |
| **Overlay**       | Multi-host communication.          | Distributed applications (Swarm/Kubernetes). |
| **Macvlan**       | Direct access to physical network. | Legacy applications requiring unique MACs.   |
| **Custom**        | User-defined networks.             | Fine-grained control over container comms.   |


---

## Summary
Docker is a versatile and powerful tool for modern application development and deployment. Its lightweight and portable nature make it a cornerstone of DevOps practices, enabling faster development cycles, consistent environments, and efficient resource usage.
