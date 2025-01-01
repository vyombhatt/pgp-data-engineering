# Terraform Comprehensive Notes

## What is Terraform?

Terraform is an open-source Infrastructure as Code (IaC) tool developed by HashiCorp. It allows users to define, provision, and manage infrastructure using high-level configuration syntax. Terraform automates the deployment of infrastructure resources across various cloud providers (like AWS, Azure, Google Cloud), as well as on-premise resources.

## Key Features of Terraform

- **Infrastructure as Code (IaC):** Allows users to describe infrastructure in configuration files, making it possible to version, share, and reuse infrastructure setups.
- **Multi-Cloud Support:** Works with a variety of cloud providers, including AWS, Azure, Google Cloud, and more.
- **Declarative Configuration Language:** Uses HashiCorp Configuration Language (HCL) to define the desired state of infrastructure resources.
- **Idempotent:** Terraform ensures that running the same configuration multiple times results in the same infrastructure state.
- **State Management:** Terraform keeps track of your infrastructure’s state, allowing it to detect changes and perform the necessary actions to reach the desired state.
- **Modules:** Terraform supports reusable components (modules), which can be shared and maintained across projects.

## Terraform Architecture

Terraform's architecture is designed to manage infrastructure through a combination of configuration files, provider plugins, state management, and execution plans. Here’s an overview of the key components that make up Terraform’s architecture:

1. **Terraform CLI (Command-Line Interface)**
   - The **Terraform CLI** is the primary tool that interacts with the user. It allows you to execute various Terraform commands like `init`, `apply`, `plan`, `validate`, and more.
   - It is responsible for reading the configuration files, interacting with the provider APIs, and updating the state file.
   - The CLI communicates with the core components of Terraform to provision, manage, and modify infrastructure.

2. **Configuration Files**
   - **Terraform Configuration Files** are where the infrastructure is defined using HashiCorp Configuration Language (HCL). These files have a `.tf` extension.
   - Configuration files declare resources, providers, modules, and other elements required to build infrastructure.

3. **Providers**
   - **Providers** are plugins that allow Terraform to interact with various cloud providers (AWS, Azure, Google Cloud, etc.) and on-premise resources (VMware, OpenStack, etc.).
   - Providers handle the creation, updating, and deletion of resources within the cloud or infrastructure environment.
   - Each provider exposes a set of resources and data sources that can be configured using Terraform.
   - The `provider.tf` file usually holds all providers.

4. **Resources**
   - **Resources** are the infrastructure components that Terraform manages, such as virtual machines, storage buckets, or networks. Resources are defined within the configuration files.
   - Terraform will create, read, update, and delete these resources as specified in the configuration.
   - The `main.tf` file usually holds all resources.

5. **State File**
   - The **state file** is a critical component of Terraform’s architecture. It maintains the current state of the infrastructure and tracks the resources that Terraform manages.
   - The `.tfstate` file is used by Terraform to determine what changes need to be applied to the infrastructure.
   - **Remote State**: In multi-team environments or when managing large infrastructure, it’s common to store the state file remotely (e.g., in Amazon S3, Terraform Cloud, etc.) to ensure consistent and safe management of the infrastructure.
   - Example of how state is used:
     - If you add a new resource in your configuration and run `terraform apply`, Terraform compares the current state (in the `.tfstate` file) to the desired state (from the configuration) and applies the necessary changes.

6. **Execution Plan**
   - Terraform uses an **execution plan** to determine the exact actions required to reach the desired state. The plan is created when you run the `terraform plan` command.
   - The execution plan shows the operations Terraform will perform, such as adding, modifying, or deleting resources. This allows you to review and approve the changes before they are applied to the infrastructure.

7. **Modules**
   - **Modules** in Terraform are reusable configurations that encapsulate groups of resources. A module can be used to define a complex infrastructure component (e.g., a VPC, database cluster) in one place and reuse it across multiple configurations.
   - Modules help improve organization and reusability of Terraform configurations. You can use both **local modules** (within your project) and **remote modules** (from the Terraform registry or GitHub).

## Basic Terraform Workflow

1. **Write Configuration Files:** Define the infrastructure components (e.g., servers, databases) in `.tf` files using HCL.
2. **Initialize the Working Directory:** Run `terraform init` to initialize the Terraform working directory and download necessary provider plugins.
3. **Plan the Execution:** Use `terraform plan` to preview the actions Terraform will take to create, modify, or destroy resources.
4. **Apply the Configuration:** Use `terraform apply` to apply the configuration and provision resources.
5. **Manage the State:** Terraform tracks changes in a `.tfstate` file, which is used to know what has been deployed and detect differences in future operations.
6. **Destroy Resources:** To tear down the infrastructure, use `terraform destroy` to remove all resources defined in the configuration files.

## Terraform Configuration Language (HCL)

HCL (HashiCorp Confirguration Language) is the declarative language used by Terraform for defining infrastructure resources. It is human-readable and structured.

### Files in the Configuration Directory

- **Provider block**: Specifies the AWS provider and its configuration (filename: *provider.tf*)
```hcl
provider "aws" {
  region = "us-west-2"
}
```
- **Resource block**: Defines the resource e.g. aws_instance, and its attributes (filename: *main.tf*)
```hcl
resource "aws_instance" "demo_name" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
}
```
- **Output block**: Defines an output variable that can be displayed after the resource is created (filename: *output.tf*)
```hcl
output "instance_id" {
  value = aws_instance.example.id
}
```
- **Variable block**: Defines all variables (filename:*variables.tf*)


## Terraform Commands

| Command                  | Description                                                                                                                                       |
|--------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------|
| `terraform init`          | Initializes a working directory containing Terraform configuration files. It installs the required provider plugins and prepares the environment mentioned in the configuration files. |
| `terraform plan`          | Creates an execution plan, showing what changes will be made to the infrastructure. It provides a preview of the actions Terraform will take.      |
| `terraform apply`         | Applies the changes specified in the execution plan. It provisions or modifies the resources defined in the configuration files.                   |
| `terraform destroy`       | Destroys the infrastructure managed by Terraform. It removes all resources defined in the configuration files.                                      |
| `terraform validate`      | Validates the syntax of the Terraform configuration files. It checks for any errors or issues before applying changes.                            |
| `terraform fmt`           | Formats the configuration files according to Terraform's style guide. It ensures consistency and readability in the code.                         |
| `terraform refresh`       | Updates the state file with the current configuration of the infrastructure. It refreshes the state file to reflect any changes made outside of Terraform.|
| `terraform output`        | Displays the values of output variables defined in the configuration files. It helps you see important details, like instance IDs or IP addresses.  |
| `terraform show`          | Displays the current state or a saved plan. It can be used to inspect resources and their attributes.                                              |
| `terraform import`        | Imports an existing resource into Terraform’s management. It brings an infrastructure component under Terraform's control without recreating it.     |
| `terraform taint`         | Marks a resource for destruction and recreation in the next apply. It forces Terraform to recreate a resource, even if no changes are made to config.|
| `terraform state`         | Manages the Terraform state file. You can list, pull, push, or modify the state file, including removing resources or moving them between modules.   |
| `terraform console`       | Starts an interactive console where you can query the state and resources or test expressions.                                                     |
| `terraform workspace`     | Manages Terraform workspaces, allowing you to have multiple environments (e.g., dev, prod) with different states within the same configuration.     |


## Terraform State

Terraform keeps track of infrastructure state through the `.tfstate` file. This file helps Terraform determine what has been created and what changes need to be applied.

Benefits of Terraform State:
- **Tracking Changes:** It stores the state of resources, which helps Terraform detect drift (differences between the actual and desired state).
- **Remote Backends:** State can be stored remotely (e.g., S3, Consul, or Terraform Cloud) for team collaboration and sharing.
- **Locking State:** With remote state, you can enable state locking to prevent simultaneous operations that could lead to conflicts.

## Terraform Modules

Modules are containers for multiple resources that are used together. They allow you to reuse code, share configurations, and organize your infrastructure.

Example of Using a Module:

```hcl
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  name   = "example-vpc"
  cidr   = "10.0.0.0/16"
}
```

In this example, the vpc module from the terraform-aws-modules/vpc/aws GitHub repository is used to create a VPC.

## Remote Backends

Remote backends allow you to store the Terraform state remotely, which is crucial for collaboration and team workflows. Common remote backends include:

- **Amazon S3:** Store the state file in an S3 bucket.
- **Terraform Cloud:** A managed service for state management and collaboration.
- **Consul:** A tool for managing services, and it can also be used to store the state.

Example Backend Configuration:

```hcl
terraform {
  backend "s3" {
    bucket = "my-terraform-state"
    key    = "state.tfstate"
    region = "us-west-2"
  }
}
```

## Terraform Lifecycles

Terraform's lifecycle defines how resources are created, updated, and destroyed. By default, Terraform follows an immutable infrastructure - this means that everytime there is an upgrade needed (e.g. need to change the type of ec2 instance) on existing infrastructure, it will have to completely delete the current infrastructure and then set up the upgraded infrastructure. Lifecycle allows us to take control of this porperty.

Key components include:

1. **Resource Lifecycle Phases**
- **Create:** Provisioning a new resource.
- **Read:** Retrieving the current state of a resource.
- **Update:** Modifying resources to match the desired state.
- **Delete:** Removing resources when no longer needed.

2. **Lifecycle Meta-Argument**
- **`create_before_destroy`:** Ensures new resources are created before old ones are destroyed, minimizing downtime. Default behavior is to destroy the resource first unless specified.
- **`prevent_destroy`:** Protects critical resources from accidental deletion.
- **`ignore_changes`:** Allows Terraform to ignore changes to specific attributes managed outside of Terraform.

Example of configuration code:
```hcl
resource "aws_instance" "example" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"

  lifecycle {
    create_before_destroy = true
    prevent_destroy       = true
    ignore_changes        = [tags]
  }
}
```
Benefits of lifecycles:
- Reduces downtime with phased resource replacement.
- Protects essential resources from accidental removal.
- Provides flexibility for managing external changes to resources.

Use Cases of lifecycles:
- Safeguarding production resources.
- Handling dynamic attributes like auto-assigned tags.
- Upgrading infrastructure without downtime.

## Conclusion

Terraform is a powerful tool for managing infrastructure as code. It simplifies provisioning, scalability, and management across cloud environments, allowing teams to automate the setup and management of resources. Through a declarative approach and robust features like state management and modules, Terraform helps ensure that infrastructure is consistent, repeatable, and manageable over time.
