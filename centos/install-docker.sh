#!/bin/bash
sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo

sudo yum install -y --nobest docker-ce-3:18.09.1-3.el7 docker-ce-cli-1:19.03.5-3.el7 containerd.io

sudo systemctl start docker
sudo systemctl enable docker

sudo usermod -aG docker $USER
