# Ubuntu Server 18.04 (LTS)

## Install Docker

### SET UP THE REPOSITORY
```bash

# Update the apt package index:
sudo apt-get -y update

# Install packages to allow apt to use a repository over HTTPS:
sudo apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common

# Add Docker’s official GPG key:
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

# Verify that you now have the key with the fingerprint 9DC8 5822 9FC7 DD38 854A E2D8 8D81 803C 0EBF CD88
# by searching for the last 8 characters of the fingerprint.
sudo apt-key fingerprint 0EBFCD88

# Use the following command to set up the stable repository
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
```

### INSTALL DOCKER ENGINE - COMMUNITY

```bash
# Update the apt package index.
sudo apt-get update

# Install the latest version of Docker Engine - Community and containerd
sudo apt-get install -y docker-ce docker-ce-cli containerd.io

# Verify that Docker Engine - Community is installed correctly by running the hello-world image.
sudo docker run hello-world
```
e
## Post-installation steps for Linux

### Manage Docker as a non-root user
```bash
# Add your user to the docker group.
sudo usermod -aG docker $USER

# Log out and log back in so that your group membership is re-evaluated.

# Verify that you can run docker commands without sudo.
docker run hello-world
docker version
```

### Configure Docker to start on boot (Optional)
By default, it's enabled

```bash
# Status first, by default, it's enabled
sudo systemctl status docker

# systemd
sudo systemctl enable docker
```

## Disable Swap (Optional)

By default, it uses all disk space. No swap.

```bash
# Before You Begin
sudo swapon --show
# If the output is empty, it means that your system does not have swap space enabled.

sudo vi /etc/fstab
# Comment out Swap
```

## Network Interfaces

### Host-Only Network - enp0s3

```bash
# Edit /etc/hostname

# Edit /etc/hosts
192.168.56.5 kubemaster
192.168.56.6 kubenode1
192.168.56.7 kubenode2
```

### NAT - enp0s8

Ubuntu Server IP address: 10.0.2.15 -- no change

## Clone the `base` VM

- Linked Clone
- Generate new MAC addresses for all network adapters

```
kubemaster
kubenode1
kubenode2
```

## Configure Ubuntu Server Static IP Address for all 3 nodes

To configure a static IP address on your Ubuntu 18.04 server you need to modify a relevant netplan network configuration file within `/etc/netplan/` directory.

* Open `/etc/netplan/01-host-only.yaml`
```yaml
network:
  version: 2
  renderer: networkd
  ethernets:
    enp0s8: # this is your interface name for your NAT network
      dhcp4: no
      addresses: [192.168.56.5/24]
      gateway4: 192.168.1.1
      nameservers:
        addresses: [192.168.1.1, 8.8.8.8, 8.8.4.4]
```

```bash
$ sudo netplan generate
$ sudo netplan apply
```

* Apply `sudo netplan apply` OR `sudo netplan --debug apply`

* Edit `sudo vim /etc/hostname`

* Edit `sudo vim /etc/hosts` with the following contents
```properties
192.168.56.5 kubemaster
192.168.56.6 kubenode1
192.168.56.7 kubenode2
```

## Establish Connection through SSH Key

- Login the master-node as root user
- Generate ssh keys `ssh-keygen` on the master-node

```bash
ssh-keygen
```

- `ssh-copy-id` from master-node to worker-nodes, which generates an entry on the worker-node `~/.ssh/authorized_keys`

```bash
# Use IP address
ssh-copy-id root@192.168.56.101
ssh-copy-id root@192.168.56.102

# OR: Use hostname if you prefer
ssh-copy-id root@node1
ssh-copy-id root@node2
```

On worker-node as a reguler user

```bash
$ cat ~/.ssh/authorized_keys
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDLTxS6D1d1f0CX/wEI0vVqjxGoNXkTzWvHLofmULt0P06pSynsCoywOaicTNTBNtuW8hd9eQZaJDKZ7pjjFRIkIJpaBrKsSncdasjikynpzi15Fy3XB9yVNssIw4guD5z/FLCsinYhkiEOJ9ntL1Hn1oV3Wq5smbop/TApUQnVVve9/k8zCN9sbufDS4Y8HCzUHoVsrnz4XwrZgqc0wkVsPkBi8HtHAf+aSoa7MuPn30UUkom/jUzeMWBKBxkQEGUNwbpe6HJIzRgKLLlaT3TKqauZOcK71T3d+glvosXMEh1gmpERfuQB5OsBdv08wLQPR9uns3NrUpr4vvxcxomtQPO/9Kx8NgAIvJdsOEg9X6fcKkT6oCyrF1X4xQVVhIbrKUVGcO6LCsKctQ0rGhqLmTDAW+s+d3azM+eGvJ8rBU2CUEdhUQUXRejz4nRyfTS2JL+pgFc/MhW5+qA4DJ1VEB4VZGJ2+zS1+7DwwQ0C1ykLZEFDnn/pqy2Di2gEkYU= mike@master
```

- Test connection from master-node to node1 & node2 (without password or key), which generates an entry on the master-node `~/.ssh/known_hosts`

```bash
# Use IP address
ssh root@192.168.56.6 # node1
ssh root@192.168.56.7 # node2

# Use hostname
ssh root@node1
ssh root@node2
```

On master-node

```bash
$ cat ~/.ssh/known_hosts
node1,192.168.56.6 ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBORukD29jNpwiR58cdeNEee/npjQx/htgtuJbmQ0LRmKeRD+U24X41urHTzDBVBjxqh5+FA8aU5asdnWkKi7m4I=
node2,192.168.56.7 ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBORukD29jNpwiR58cdeNEee/npjQx/htgtuJbmQ0LRmKeRD+U24X41urHTzDBVBjxqh5+FA8aU5asdnWkKi7m4I=
```

## Install `kubeadm, kubectl, kubelet` on `kubemaster` node

