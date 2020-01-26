#!/bin/bash
sudo yum update

sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo

sudo yum remove -y podman-manpages
sudo yum install -y --nobest docker-ce docker-ce-cli containerd.io

sudo yum clean all

sudo systemctl start docker
sudo systemctl enable docker

sudo usermod -aG docker $USER
