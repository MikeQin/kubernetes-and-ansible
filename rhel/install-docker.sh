#!/bin/bash

# Install docker ce
sudo yum update -y
sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
sudo yum makecache fast
# Make sure it's the latest of selinux when you are installing
sudo yum install -y http://mirror.centos.org/centos/7/extras/x86_64/Packages/container-selinux-2.107-3.el7.noarch.rpm
sudo yum install -y docker-ce
sudo yum update -y

# Start docker
sudo systemctl start docker

# Enable docker
sudo systemctl enable docker
