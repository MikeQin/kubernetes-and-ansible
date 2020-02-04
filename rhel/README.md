# Install Kubernetes Cluster on Redhat Enterprise Linux

### Static Network Settings

For example, to configure an interface with static network settings using `ifcfg` files, for an interface with the name `eth0`, create a file with the name `ifcfg-eth0` in the `/etc/sysconfig/network-scripts/` directory, that contains:

```
sudo vim /etc/sysconfig/network-scripts/ifcfg-eth0
```

```
DEVICE=eth0
BOOTPROTO=none
ONBOOT=yes
PREFIX=24
IPADDR=10.0.1.27
```

### Verify the MAC address and product_uuid are unique for every node

- You can get the MAC address of the network interfaces using the
  command `ip link` or `ifconfig -a`

- The product_uuid can be checked by using the command:

```
sudo cat /sys/class/dmi/id/product_uuid
```

### Ensure iptables tooling does not use the nftables backend

```
update-alternatives --set iptables /usr/sbin/iptables-legacy
```

### Disable Swap in `/etc/fstab`

```
sudo vim /etc/fstab
```

then reboot the machine to take effect.

### Install Docker CE

See [install-docker.sh](./install-docker.sh)

```

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

```

### Grant Permission: Add current user to 'docker' group

```
sudo usermod -aG docker $USER
```

OR: Modify `sudo vim /etc/group`,
and add user to the end of 'docker' group

```
docker:x:993:$USER
```

#### References

- Get Docker Engine - Community for CentOS, https://docs.docker.com/install/linux/docker-ce/centos/
- Post-installation steps for Linux, https://docs.docker.com/install/linux/linux-postinstall/

### Install `kubeadm` on CentOS

See [install-kubeadm.sh](./install-kubeadm.sh)

```
sudo su

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

yum install -y kubelet kubeadm kubectl --disableexcludes=kubernetes

systemctl enable --now kubelet

cat <<EOF > /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF

sysctl --system

lsmod | grep br_netfilter
modprobe br_netfilter

systemctl daemon-reload
systemctl restart kubelet

yum update

exit
```

## Create Kubernetes Cluster

- Create K8s cluster

```
# sudo kubeadm init <args>

sudo kubeadm init --apiserver-advertise-address=10.157.163.243 --pod-network-cidr=10.244.0.0/16
```

- Verify the cluster

```
sudo systemctl status kubelet
```

- To start using your cluster, you need to run the following as a regular user:

```
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
# sudo chown didn't work here below:
# sudo chown $(id -u):$(id -g) $HOME/.kube/config
```

Alternatively, if you are the root user, you can run:
My preference runs as a root user

```
export KUBECONFIG=/etc/kubernetes/admin.conf
```

- You should now deploy a pod network to the cluster.
  Run `kubectl apply -f [podnetwork].yaml` with one of the options listed at:
  https://kubernetes.io/docs/concepts/cluster-administration/addons/

```
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/2140ac876ef134e0ed5af15c65e414cf26827915/Documentation/kube-flannel.yml
```

- Verify and check CoreDNS Pod is running:

```
kubectl get pods --all-namespaces
```

- Then you can join any number of worker nodes by running the following on each as root:

1. SSH to the nodes
2. Become root (sudo su)
3. Run:

```
kubeadm join 10.157.163.243:6443 --token hnfjhy.2yrurw2378j5nrbf \
    --discovery-token-ca-cert-hash sha256:24eb40e8179430f1244ad00c9c845fbb867072cbb146e3dfdb42105ad5c57296
```

General format of `kubeadm join`:

```
kubeadm join --token <token> <control-plane-host>:<control-plane-port> --discovery-token-ca-cert-hash sha256:<hash>
```

4. If you do not have the token, you can get it by running the following command on the control-plane node:

```
kubeadm token list
```

By default, tokens expire after 24 hours. If you are joining a node to the cluster after the current token has expired, you can create a new token by running the following command on the control-plane node:

```
kubeadm token create
```

If you don’t have the value of `--discovery-token-ca-cert-hash`, you can get it by running the following command chain on the control-plane node:

```
openssl x509 -pubkey -in /etc/kubernetes/pki/ca.crt | openssl rsa -pubin -outform der 2>/dev/null | \
   openssl dgst -sha256 -hex | sed 's/^.* //'
```

## Tear Down

To undo what kubeadm did, you should first drain the node and make sure that the node is empty before shutting it down.

Talking to the control-plane node with the appropriate credentials, run:

```
kubectl drain <node name> --delete-local-data --force --ignore-daemonsets
kubectl delete node <node name>
```

Then, on the node being removed, reset all kubeadm installed state:

```
kubeadm reset
```

The reset process does not reset or clean up iptables rules or IPVS tables. If you wish to reset iptables, you must do so manually:

```
iptables -F && iptables -t nat -F && iptables -t mangle -F && iptables -X
```

If you want to reset the IPVS tables, you must run the following command:

```
ipvsadm -C
```

If you wish to start over simply run kubeadm init or kubeadm join with the appropriate arguments.

## Kubernetes Official Reference

- Creating a single control-plane cluster with kubeadm, https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm/
