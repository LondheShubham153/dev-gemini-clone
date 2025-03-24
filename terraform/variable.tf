# aws variable
variable "aws_region" {
  description = "The AWS region to deploy resources in."
  type = string
  default     = "eu-west-1"
}

# EC2 instance variables
variable "aws_instance_type" {
  description = "Defines the type of EC2 instance to be created (e.g., t2.micro, t3.small)."
  type        = string
  default     = "t2.large"
}

variable "aws_instance_name" {
  description = "Specifies the name tag for the EC2 instance, providing easy identification in AWS."
  type        = string
  default     = "gemini_instance"
}

variable "aws_instance_os_type" {
  description = "Defines the operating system image filter for selecting an appropriate AMI (e.g., Ubuntu 20.04)."
  type        = string
  default     = "ubuntu/images/hvm-ssd/*amd64*"
}

variable "aws_ami_owners" {
  description = "The owner ID of the AMI to use. Default is Canonical (for Ubuntu AMIs)."
  type        = string
  default     = "099720109477"
}

variable "aws_instance_storage_size" {
  description = "Specifies the size of the root block storage for the EC2 instance, in GB."
  type        = number
  default     = 30
}

variable "aws_instance_volume_type" {
  description = "Defines the volume type for the EC2 instance (e.g., gp2, gp3, io1)."
  type        = string
  default     = "gp3"
}

# Key pair variables
variable "aws_key_pair_name" {
  description = "The name of the SSH key pair to use for accessing the EC2 instance."
  type        = string
  default     = "gemini-instance-key"
}

variable "aws_key_pair_public_key" {
  description = "The path to the public key file for the SSH key pair."
  type        = string
  default     = "gemini-instance-key.pub"
}

# Security group variables
variable "aws_sg_name" {
  description = "Defines the name of the AWS Security Group to be created."
  type        = string
  default     = "gemini-instance-sg"
}

variable "aws_sg_description" {
  description = "Describes the purpose of the AWS Security Group being created."
  type        = string
  default     = "This security group allows SSH, HTTP, and HTTPS traffic."
}

variable "ssh_protocol" {
  description = "Specifies the protocol to use for SSH traffic (default: TCP)."
  type        = string
  default     = "tcp"
}

variable "http_protocol" {
  description = "Specifies the protocol to use for HTTP traffic (default: TCP)."
  type        = string
  default     = "tcp"
}

variable "https_protocol" {
  description = "Specifies the protocol to use for HTTPS traffic (default: TCP)."
  type        = string
  default     = "tcp"
}

variable "ssh_cidr" {
  description = "Defines the CIDR block to allow SSH access (default: open to all)."
  type        = string
  default     = "0.0.0.0/0"
}

variable "http_cidr" {
  description = "Defines the CIDR block to allow HTTP access (default: open to all)."
  type        = string
  default     = "0.0.0.0/0"
}

variable "https_cidr" {
  description = "Defines the CIDR block to allow HTTPS access (default: open to all)."
  type        = string
  default     = "0.0.0.0/0"
}

variable "outgoing_protocol" {
  description = "Specifies the protocol for all outgoing traffic (default: allow all)."
  type        = string
  default     = "-1"
}

variable "outgoing_cidr" {
  description = "Defines the CIDR block for all outgoing traffic (default: open to all)."
  type        = string
  default     = "0.0.0.0/0"
}