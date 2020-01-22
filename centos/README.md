# Kubernetes Cluster on CentOS

### Install Docker CE
- SET UP THE REPOSITORY

```
sudo yum update
sudo yum install -y yum-utils
```

```
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
```

- INSTALL DOCKER ENGINE - COMMUNITY
```
## To solve podman-manpages conflict, remove podman-manpages
sudo yum remove -y podman-manpages

sudo yum clean all

sudo yum install -y --nobest docker-ce docker-ce-cli containerd.io

sudo systemctl start docker

sudo systemctl enable docker
```

- Manage Docker as a non-root user
```
sudo usermod -aG docker $USER
```

-- Issue with Docker Installation
```
# Uninstall podman before updating it
sudo yum -y remove podman

# And install it back w/o manpages:
# install all podman dependencies except podman-manpages
sudo yum -y install oci-systemd-hook libvarlink

# and install podman w/o dependencies
sudo rpm -Uvh --nodeps $(repoquery --location podman)
```

### Install Kubeadm

### Create Kubernetes Cluster
