# Kubernetes & Ansible

### Alias

```bash
alias ll='ls -laFG'
alias k='kubectl'
alias kg='kubectl get'
alias kd='kubectl describe'
alias kc='kubectl create'
alias ka='kubectl apply'
alias ke='kubectl explain'
alias kr='kubectl run'
```

### Install `kubectl` client on Mac

https://kubernetes.io/docs/tasks/tools/install-kubectl/#install-kubectl-on-macos

```bash
# Latest version
curl -LO "https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/darwin/amd64/kubectl"

# for version 1.15.5
curl -LO https://storage.googleapis.com/kubernetes-release/release/v1.15.5/bin/darwin/amd64/kubectl

chmod +x ./kubectl

sudo mv ./kubectl /usr/local/bin/kubectl

kubectl version --client
```

This repository has set of ansible playbooks created to setup a kubernetes cluster fully automated with one master and multiple worker nodes. This will work on physical servers, virtual machines, aws cloud, google cloud or any other cloud servers. This has been tested and verified on Centos 7.3 64 bit operating systems. Also you can refer this link for manual configuration https://www.learnitguide.net/2018/08/install-and-configure-kubernetes-cluster.html

How to use this (Setup Instructions):

1. Make your servers ready (one master node and multiple worker nodes).
2. Make an entry of your each hosts in /etc/hosts file for name resolution.
3. Make sure kubernetes master node and other worker nodes are reachable between each other.

4. Internet connection must be enabled in all nodes, required packages will be downloaded from kubernetes official yum repository.
5. Clone this repository into your master node.

   git clone https://github.com/learnitguide/kubernetes-and-ansible.git

   once it is cloned, get into the directory

   cd kubernetes-and-ansible/centos

6. There is a file "hosts" available in "centos" directory, Just make your entries of your all kubernetes nodes.
7. Provide your server details in "env_variables" available in "centos" directory.
8. Deploy the ssh key from master node to other nodes for password less authentication.

   ssh-keygen

   Copy the public key to all nodes including your master node and make sure you are able to login into any nodes without password.

9. Run "settingup_kubernetes_cluster.yml" playbook to setup all nodes and kubernetes master configuration.

   ansible-playbook settingup_kubernetes_cluster.yml

10. Run "join_kubernetes_workers_nodes.yml" playbook to join the worker nodes with kubernetes master node once "settingup_kubernetes_cluster.yml" playbook tasks are completed.

    ansible-playbook join_kubernetes_workers_nodes.yml

11. Verify the configuration from master node.

    kubectl get nodes

What are the files this repository has?:

ansible.cfg - Ansible configuration file created locally.

hosts - Ansible Inventory File

env_variables - Main environment variable file where we have to specify based on our environment.

settingup_kubernetes_cluster.yml - Ansible Playbook to perform prerequisites ready, setting up nodes, configure master node.

configure_worker_nodes.yml - Ansible Playbook to join worker nodes with master node.

clear_k8s_setup.yml - Ansible Playbook helps to delete entire configurations from all nodes.

playbooks - Its a directory holds all playbooks.

Who we are?

We (learnitguide.net) provide you all complete step by step procedures, How to, Installations, configurations, Implementations, documentations, on-line trainings, easy guides on Linux, Cloud Computing, Openstack, Puppet, Chef, Ansible, Devops, Docker, Kubernetes, Linux clusters, VCS Cluster, Virtualizations and other technologies

For more updates, stay connect with us on

Youtube Channel : https://www.youtube.com/learnitguide

Facebook : http://www.facebook.com/learnitguide

Twitter : http://www.twitter.com/learnitguide

Visit our Website : https://www.learnitguide.net

## Configure Static IP on CentOS

- Login with 'root' user.

- Edit `ifcfg-enp0s3` file as per the following code. (In vi editor, use 'i' for insert, 'esc' key to enter command mode and 'wq' for save and quit)

`vim /etc/sysconfig/network-scripts/ifcfg-enp0s3`

```properties
ONBOOT=yes
USERCTL=no
```

- Edit `ifcfg-enp0s8` file as per the following code. (Note. IPADDR value should be in between Lower Address Bound and Upper Address Bound values)

`vim /etc/sysconfig/network-scripts/ifcfg-enp0s8`

```properties
BOOTPROTO=none
ONBOOT=yes
IPADDR=192.168.56.3 ## The Lower Address Bound from Host-Only Network
PREFIX=24
```

- Restart network OR reboot

```bash
systemctl restart NetworkManager
```

- Make entries in `/etc/hosts` for all nodes

```
192.168.56.3   rancher
192.168.56.100 master
192.168.56.101 node1
192.168.56.102 node2
```

- Test with the ping command, try it in a Windows Command Prompt window (CMD).

```cmd
Microsoft Windows [Version 10.0.17763.253]
(c) 2018 Microsoft Corporation. All rights reserved.

C:\Users\tutorial>ping 192.168.56.141

Pinging 192.168.56.141 with 32 bytes of data:
Reply from 192.168.56.141: bytes=32 time=1ms TTL=64
Reply from 192.168.56.141: bytes=32 time<1ms TTL=64
Reply from 192.168.56.141: bytes=32 time=1ms TTL=64
Reply from 192.168.56.141: bytes=32 time=1ms TTL=64

Ping statistics for 192.168.56.141:
    Packets: Sent = 4, Received = 4, Lost = 0 (0% loss),
Approximate round trip times in milli-seconds:
    Minimum = 0ms, Maximum = 1ms, Average = 0ms
```

Source: https://qiita.com/Tutorial/items/5ab1ec4ba55396b089f8

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
ssh root@192.168.56.101 # node1
ssh root@192.168.56.102 # node2

# Use hostname
ssh root@node1
ssh root@node2
```

On master-node

```bash
$ cat ~/.ssh/known_hosts
node1,192.168.56.101 ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBORukD29jNpwiR58cdeNEee/npjQx/htgtuJbmQ0LRmKeRD+U24X41urHTzDBVBjxqh5+FA8aU5asdnWkKi7m4I=
node2,192.168.56.102 ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBORukD29jNpwiR58cdeNEee/npjQx/htgtuJbmQ0LRmKeRD+U24X41urHTzDBVBjxqh5+FA8aU5asdnWkKi7m4I=
```

## Disable Firewall on CentOS 8

CentOS by default enables firewall.

Firewall on master-node and worker-nodes MUST be Disabled Permanently to ensure the route/communication work among nodes in kube cluster.

1. Check the firewall status

```bash
sudo firewall-cmd --state

running
```

2. To permanently disable the firewall on your CentOS system, follow the steps below:

```bash
# First, stop the FirewallD service with:
sudo systemctl stop firewalld

# Disable the FirewallD service to start automatically on system boot:
sudo systemctl disable firewalld

Removed /etc/systemd/system/multi-user.target.wants/firewalld.service.
Removed /etc/systemd/system/dbus-org.fedoraproject.FirewallD1.service.

# Mask the FirewallD service which will prevent the firewall from being started by other services:
sudo systemctl mask --now firewalld

# As you can see from the output the mask command simply creates a symlink from the firewalld service to /dev/null
Created symlink /etc/systemd/system/firewalld.service → /dev/null.

# Check the status again
sudo firewall-cmd --state

not running
```

To unmask and enable firewalld

```bash
sudo systemctl unmask --now firewalld.service
sudo systemctl enable --now firewalld.service
sudo systemctl start --now firewalld.service
sudo systemctl status firewalld.service
```

## Install Python3 on CentOS 8

- Better to install with regular user

- Install Python3

```
sudo yum update
sudo yum install python3
```

- Check Verstion

```
python3 -V
```

## Install Ansible on CentOS 8

- Login as a regular user. Better to install with regular user

```
pip3 install ansible --user
```

- Check Version

```
ansible --version
```

- Test Connections as a user, not the root

```
ansible localhost -m ping
ansible remote_hostname -m ping
ansible -i /etc/ansible/hosts [groupName] -m ping
ansible -i /etc/ansible/hosts workers -m ping
```

## Run Ansible Playbook

```
ansible-playbook settingup_kubernetes_cluster.yml

ansible-playbook join_kubernetes_workers_nodes.yml
```
