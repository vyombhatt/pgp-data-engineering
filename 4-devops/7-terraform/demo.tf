terraform {
    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = "~> 5.0"
        }
    }
}

# Define the provider, region and user access keys

provider "aws" {
    region = "ap-south-1"
    access_key = "AKAAGISYHAHSKK" # this is from the key downloaded when creating new user
    secret_key = "" # this is from the key downloaded when creating new user
}

# If we want to start an ec2 cluster, we need to choose the amazon machine image e.g. ubuntu, aws linux
# Each machine (AMI) has it's own AMI ID
# In order to get terraform to automatically pick up this ID, we can use concept of data sources
# Here we define the data source named "aws_ami" to filter for most recent ami ID for amazon linux machine

data "aws_ami" "linux" {

    most_recent = true

    filter {
        name = "name"
        values = ["amzn2-ami-hvm-*"] # this is a generic name value for amazon linux machines
    }

    filter {
        name = "virtualization-type"
        values = ["hvm"]
    }

    owners = ["amazon"]
}

# Finally define the resource we want to create
# Creating a t2.micro ec2 instance named "mydemoinstance"

resource "aws_instance" "mydemoinstance" {
    instance_type = "t2.micro"
    ami = data.aws_ami.linux.id
    key_name = aws_key_pair.demokeypair.id # Add the aws_key_pair resource created in line 54
    tags = {
        Name = "mydemoinstance"
    }
}

# To attach ssh-key to the cluster to allow for remote access, we need to provide it a public key
# Here, we provide the path to the public key created when creating the new ec2 user
resource "aws_key_pair" "demokeypair" {
    public_key = file("/home/demouser/.ssh/id_rsa.pub")
}

