# Kubernetes & Ansible

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

* Login with 'root' user.

* Edit `ifcfg-enp0s3` file as per the following code. (In vi editor, use 'i' for insert, 'esc' key to enter command mode and 'wq' for save and quit)

`vi /etc/sysconfig/network-scripts/ifcfg-enp0s3`

```properties
ONBOOT=yes
USERCTL=no
```
* Edit `ifcfg-enp0s8` file as per the following code. (Note. IPADDR value should be in between Lower Address Bound and Upper Address Bound values)

`vi /etc/sysconfig/network-scripts/ifcfg-enp0s8`

```properties
BOOTPROTO=none
ONBOOT=yes
IPADDR=192.168.56.141
PREFIX=24
```
* Restart network OR reboot
```bash
systemctl restart network
```
```bash
reboot
```
* Test with the ping command, try it in a Windows Command Prompt window (CMD).

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

* Generate SSH Keys
```bash
ssh-keygen
```

* SSH Copy ID
```
ssh-copy-id -f root@192.168.56.100
ssh-copy-id -f root@192.168.56.101
ssh-copy-id -f root@192.168.56.102
```

* Test Connection from Master to Node1 & Node2
```
ssh root@192.168.56.101 # node1
ssh root@192.168.56.102 # node2
```

## Install Python3 on CentOS 8

* Better to install with regular user

* Install Python3
```
sudo dnf update
sudo dnf install python3
```

* Check Verstion
```
python3 -V
```

## Install Ansible on CentOS 8

* Better to install with regular user
```
pip3 install ansible --user
```

* Check Version
```
ansible --version
```

* Test Connections
```
ansible localhost -m ping
ansible -i /etc/ansible/hosts [groupName] -m ping
ansible -i /etc/ansible/hosts workers -m ping
```

## Run Ansible Playbook
```
ansible-playbook settingup_kubernetes_cluster.yml

ansible-playbook join_kubernetes_workers_nodes.yml
```
