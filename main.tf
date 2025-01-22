terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0.0"
    }
  }

  required_version = ">= 1.0.0"
}

provider "aws" {
  region = var.region
}

data "aws_subnet_ids" "selected_subnet" {
  vpc_id = var.vpc_id
}
resource "aws_instance" "vm_instance" {
  ami           = var.ami_id
  instance_type = var.instance_type

  subnet_id = data.aws_subnet_ids.selected_subnet.ids[0]

  tags = {
    Name = var.instance_name
  }

  # Use a key pair for SSH access
  key_name = var.key_pair_name

  # Optionally associate a security group
  vpc_security_group_ids = [aws_security_group.vm_sg.id]
}

resource "aws_security_group" "vm_sg" {
  name        = "${var.instance_name}-sg"
  description = "Security group for ${var.instance_name}"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow SSH from anywhere (modify for security)
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow HTTP traffic
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow HTTPS traffic
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"] # Allow all outbound traffic
  }
}

output "instance_id" {
  value = aws_instance.vm_instance.id
}

output "public_ip" {
  value = aws_instance.vm_instance.public_ip
}
