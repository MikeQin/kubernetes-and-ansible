#!/bin/bash
# login as a root user
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

sudo kubeadm init --apiserver-advertise-address=10.157.163.243 \
--pod-network-cidr=10.244.0.0/16

exit

mkdir -p $HOME/.kube
chmod 777 $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
## sudo chown $(id -u):$(id -g) $HOME/.kube/config

# Alternatively, if you are the root user, you can run:
export KUBECONFIG=/etc/kubernetes/admin.conf

# Install a POD network add-on
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/2140ac876ef134e0ed5af15c65e414cf26827915/Documentation/kube-flannel.yml

# Verify and check CoreDNS Pod is running:
kubectl get pods --all-namespaces

# On a worker node as root
kubeadm join 10.157.163.243:6443 --token hnfjhy.2yrurw2378j5nrbf \
    --discovery-token-ca-cert-hash sha256:24eb40e8179430f1244ad00c9c845fbb867072cbb146e3dfdb42105ad5c57296