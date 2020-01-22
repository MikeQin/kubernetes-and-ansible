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
sudo usermod -aG docker \$USER
```

OR: Modify `sudo vim /etc/group`,
and add user to the end of 'docker' group

```
docker:x:993:\$USER
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

exit
```

### Create Kubernetes Cluster

```
sudo kubeadm init <args>

sudo kubeadm init --apiserver-advertise-address=10.157.163.243 --pod-network-cidr=10.244.0.0/16
```
