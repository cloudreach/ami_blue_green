
packer {
  required_plugins {
    amazon = {
      version = ">= 0.0.2"
      source  = "github.com/hashicorp/amazon"
    }
  }
}
locals {
  timestamp = regex_replace(timestamp(), "[- TZ:]", "")
}

variable "green_ami_prefix" {
  type    = string
  default ="green_ami"
}

variable "blue_ami_prefix" {
  type    = string
  default ="blue_ami"
}

variable "bldeploy"{
  type = string
  default = "blue"
}

variable "grdeploy"{
  type = string
  default = "green"
}



source "amazon-ebs" "ubuntu_blue" {
  ami_name      = "${var.blue_ami_prefix}-${local.timestamp}"
  instance_type = "t2.micro"
  region        = "eu-west-1"
  vpc_id        = "vpc-07879b87cad947f3f"
  subnet_id     = "subnet-0beb3ccb0f1dae9b3"
  source_ami_filter {
    filters = {
      name                = "ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["099720109477"]
  }
  ssh_username = "ubuntu"
}
source "amazon-ebs" "ubuntu-focal" {
  ami_name      = "${var.green_ami_prefix}-${local.timestamp}"
  instance_type = "t2.micro"
  region        = "eu-west-1"
  vpc_id        = "vpc-07879b87cad947f3f"
  subnet_id     = "subnet-0beb3ccb0f1dae9b3"
  source_ami_filter {
    filters = {
      name                = "ubuntu/images/*ubuntu-focal-20.04-amd64-server-*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["099720109477"]
  }
  ssh_username = "ubuntu"
}
 

build {
  name = "learn-packer"
  sources = [
    #"source.amazon-ebs.ubuntu_blue",
    "source.amazon-ebs.ubuntu-focal"
  ]
  provisioner "ansible" {
    playbook_file = "./playbooks/main.yml"
    extra_arguments = ["--extra-vars", "color=${var.grdeploy}"]
  }
}
build {
  name = "learn-packer"
  sources = [
    "source.amazon-ebs.ubuntu_blue",
    #"source.amazon-ebs.ubuntu-focal"
  ]
  provisioner "ansible" {
    playbook_file = "./playbooks/main.yml"
    extra_arguments = ["--extra-vars", "color=${var.bldeploy}"]
  }
}