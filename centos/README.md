# Kubernetes Cluster on CentOS

With Docker 1.13 update, we can easily remove both unwanted containers, dangling images

```bash
$ docker system df #will show used space, similar to the unix tool df
$ docker system prune # will remove all unused data.
```
## Kubernetes Reference

* Installing kubeadm, https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/
* Creating a single control-plane cluster with kubeadm, https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm/
* How to Install a Kubernetes Cluster on CentOS 8 , https://www.tecmint.com/install-a-kubernetes-cluster-on-centos-8/
  
## Install Docker CE
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

sudo yum install -y --nobest docker-ce docker-ce-cli containerd.io

sudo yum clean all

sudo systemctl start docker

sudo systemctl enable docker
```

- Manage Docker as a non-root user
```
sudo usermod -aG docker $USER

# Reboot the machine
reboot

# After reboot, verify `docker` without `sudo`
docker version
```

## Installing `kubeadm, kubelet and kubectl`

### Before Begin

1) Disable Swap
```
sudo vim /etc/fstab
```

2) Verify the MAC address and product_uuid

MAC address
```
ip link

# OR

ifconfig -a
```

product_uuid
```
sudo cat /sys/class/dmi/id/product_uuid
```

3) Check `iptables` Tooling (does not use the nftables backend)

```
update-alternatives --set iptables /usr/sbin/iptables-legacy
```

### Installing

- Run as `root`

```
yum update
yum clean all
```

Install:
```
cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF

# Set SELinux in permissive mode (effectively disabling it)
setenforce 0
sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config

# Since firewall must be disabled permanently, the following is not necessary.
# Configure the firewall rules on the ports as root user
# Ref: https://www.tecmint.com/install-a-kubernetes-cluster-on-centos-8/
# firewall-cmd --permanent --add-port=6443/tcp
# firewall-cmd --permanent --add-port=2379-2380/tcp
# firewall-cmd --permanent --add-port=10250/tcp
# firewall-cmd --permanent --add-port=10251/tcp
# firewall-cmd --permanent --add-port=10252/tcp
# firewall-cmd --permanent --add-port=10255/tcp
# firewall-cmd –-reload

# Make sure the value is 1
cat /proc/sys/net/bridge/bridge-nf-call-iptables
# Make sure the value is 1, otherwise:
# echo '1' > /proc/sys/net/bridge/bridge-nf-call-iptables

# Install kubeadm... etc.
yum install -y --nobest kubelet kubeadm kubectl --disableexcludes=kubernetes

systemctl enable --now kubelet
```

You should ensure `net.bridge.bridge-nf-call-iptables` is set to 1 in your `sysctl` config, e.g.
```
cat <<EOF > /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
sysctl --system
```

Make sure that the `br_netfilter` module is loaded before this step. 
This can be done by running:
```
lsmod | grep br_netfilter
modprobe br_netfilter
```

```
systemctl daemon-reload
systemctl restart kubelet
```

## Create Kubernetes Cluster

### Install a single control-plane Kubernetes cluster

* Prepare: Pull images

```
kubeadm config images pull
```

* Initialize the control-plane node

```
kubeadm init <args>

kubeadm init --apiserver-advertise-address=192.168.56.100 \
  --pod-network-cidr=10.244.0.0/16
```

* To make kubectl work for your non-root user
```
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
```
Alternatively, if you are the root user, you can run:
```
export KUBECONFIG=/etc/kubernetes/admin.conf
```

* Make a record of the kubeadm join command that kubeadm init outputs.

### Install a Pod network on the cluster

* Set `/proc/sys/net/bridge/bridge-nf-call-iptables` to 1 by running:
```
sudo sysctl net.bridge.bridge-nf-call-iptables=1
```

* Install Flannel

```
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/2140ac876ef134e0ed5af15c65e414cf26827915/Documentation/kube-flannel.yml
```

* Once a Pod network has been installed, confirm it working by checking CoreDNS Pod is running.

```
kubectl get pods --all-namespaces
```

### Firewall Check

```bash
# Check the Master-Node connectivity
nc -vz 192.168.56.100 6443

# Check iptables
sudo iptables -nvL

# Status firewall
sudo systemctl status firewalld

# Restart firewall if necessary
sudo systemctl restart firewalld

# Stop firewall
sudo systemctl stop firewalld

# Disable firewall
sudo systemctl disable firewalld
```

### Joining Your Nodes

* SSH to the machine
* Become root (e.g. sudo su)
* Run the command that was output by kubeadm init. For example:

```
systemctl enable kubelet.service

# General format
kubeadm join --token <token> <control-plane-host>:<control-plane-port> --discovery-token-ca-cert-hash sha256:<hash>

# Actual code
kubeadm join 192.168.56.100:6443 --token nndczt.nbvkmh27dymisw8r \
    --discovery-token-ca-cert-hash sha256:a9d3e839d7aa6633b4f0b13b8aeeb9ca34f1a4d0ae454bf243b4de7913052f1d
```

* Verify as a regular user on Master-Node, not the root
```
kubectl get nodes
```

Results:
```
NAME     STATUS   ROLES    AGE    VERSION
master   Ready    master   106m   v1.17.2
node1    Ready    <none>   15m    v1.17.1
node2    Ready    <none>   115s   v1.17.1
```