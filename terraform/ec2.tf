# Fetch the AMI for the instance based on specified filters
data "aws_ami" "ubuntu" {
    owners      = [var.aws_ami_owners]
    most_recent = true

    filter {
        name   = "name"
        values = [var.aws_instance_os_type]
    }

    filter {
        name   = "state"
        values = ["available"]
    }
}

# Create an SSH key pair
resource "aws_key_pair" "terraform_key" {
    key_name   = var.aws_key_pair_name
    public_key = file(var.aws_key_pair_public_key)
}

# Get the default VPC for the region
resource "aws_default_vpc" "default" {}

# Create a security group
resource "aws_security_group" "terraform_sg" {
    name        = var.aws_sg_name
    description = var.aws_sg_description
    vpc_id      = aws_default_vpc.default.id

    ingress {
        description = "Allow access to SSH port 22"
        from_port   = 22
        to_port     = 22
        protocol    = var.ssh_protocol
        cidr_blocks = [var.ssh_cidr]
    }

    ingress {
        description = "Allow access to HTTP port 80"
        from_port   = 80
        to_port     = 80
        protocol    = var.http_protocol
        cidr_blocks = [var.http_cidr]
    }

    ingress {
        description = "Allow access to HTTPS port 443"
        from_port   = 443
        to_port     = 443
        protocol    = var.https_protocol
        cidr_blocks = [var.https_cidr]
    }
    ingress {
        description = "Allow access to custom port 3000"
        from_port   = 3000  
        to_port     = 3000
        protocol    = var.https_protocol
        cidr_blocks = [var.https_cidr]
    }
    ingress {
        description = "Allow access to jenkins port 8080"
        from_port   = 8080
        to_port     = 8080
        protocol    = var.https_protocol
        cidr_blocks = [var.https_cidr]
    }
    ingress {
        description = "Allow access to SonarQube port 9000"
        from_port   = 9000  
        to_port     = 9000
        protocol    = var.https_protocol
        cidr_blocks = [var.https_cidr]
    }
    ingress {
        description = "Allow access to SMTPS port 465"
        from_port   = 465
        to_port     = 465
        protocol    = var.https_protocol
        cidr_blocks = [var.https_cidr]
    }

    egress {
        description = "Allow all outgoing traffic"
        from_port   = 0
        to_port     = 0
        protocol    = var.outgoing_protocol
        cidr_blocks = [var.outgoing_cidr]
    }

    tags = {
        Name = var.aws_sg_name
    }
}

# Create an EC2 instance
resource "aws_instance" "gemini_instance" {
    count = 2
    ami           = data.aws_ami.ubuntu.id
    instance_type = var.aws_instance_type
    key_name      = aws_key_pair.terraform_key.key_name
    security_groups = [aws_security_group.terraform_sg.name]

    root_block_device {
        volume_size = var.aws_instance_storage_size
        volume_type = var.aws_instance_volume_type
    }

    tags = {
        Name = var.aws_instance_name
    }
}