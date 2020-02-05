# Install `kubeadm, kubelet and kubectl` on All Nodes

## Prerequites

Meet all requirements

#### Disable Swap

```bash
sudo swapon --show
```

* Disable it in `sudo vim /etc/fstab`
* Reboot

## Check IP route(s)
If you have more than one network adapter, and your Kubernetes components are not reachable on the default route, we recommend you add IP route(s) so Kubernetes cluster addresses go via the appropriate adapter.

* Display Existing Routing Table
```bash
ip route show
```
Output:
```bash
root@kubemaster:/home/mike# ip route show
default via 10.0.2.2 dev enp0s3 proto dhcp src 10.0.2.15 metric 100
10.0.2.0/24 dev enp0s3 proto kernel scope link src 10.0.2.15
10.0.2.2 dev enp0s3 proto dhcp scope link src 10.0.2.15 metric 100
172.17.0.0/16 dev docker0 proto kernel scope link src 172.17.0.1 linkdown
192.168.56.0/24 dev enp0s8 proto kernel scope link src 192.168.56.5
```

## Ensure iptables tooling does not use the nftables backend

```bash
# ensure legacy binaries are installed
sudo apt-get install -y iptables arptables ebtables

# switch to legacy versions
sudo update-alternatives --set iptables /usr/sbin/iptables-legacy
sudo update-alternatives --set ip6tables /usr/sbin/ip6tables-legacy
sudo update-alternatives --set arptables /usr/sbin/arptables-legacy
sudo update-alternatives --set ebtables /usr/sbin/ebtables-legacy
```

## Installing `kubeadm, kubelet and kubectl` on All Nodes
```bash
sudo apt-get update && sudo apt-get install -y apt-transport-https curl
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
cat <<EOF | sudo tee /etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF
sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl
```

# Creating a single control-plane cluster with kubeadm

```bash
apt-get update && apt-get upgrade
```

## Initialize on Master Node Only
```bash
# kubeadm config images pull

kubeadm init --pod-network-cidr=10.244.0.0/16 --apiserver-advertise-address=192.168.56.5
```

* Make a record of the kubeadm join command that kubeadm init outputs. You need this command to join nodes to your cluster.

```
Your Kubernetes control-plane has initialized successfully!

To start using your cluster, you need to run the following as a regular user:

  mkdir -p $HOME/.kube
  sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  sudo chown $(id -u):$(id -g) $HOME/.kube/config

You should now deploy a pod network to the cluster.
Run "kubectl apply -f [podnetwork].yaml" with one of the options listed at:
  https://kubernetes.io/docs/concepts/cluster-administration/addons/

Then you can join any number of worker nodes by running the following on each as root:

kubeadm join 192.168.56.5:6443 --token j6osap.2jlde0gmczjad5kp \
    --discovery-token-ca-cert-hash sha256:d16d3204fc9f82766785ada512af2cea64be645fbb347433a8979ebf31945e94
```

* To make kubectl work for your non-root user, run these commands, which are also part of the kubeadm init output:

```bash
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
```

## Installing a Pod network add-on - Flannel (Master)
```bash
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/2140ac876ef134e0ed5af15c65e414cf26827915/Documentation/kube-flannel.yml
```

* Check all
```
kubectl get all --all-namespaces
kubectl get nodes
```

## Joining your nodes (Node1 & Node2)

The nodes are where your workloads (containers and Pods, etc) run. To add new nodes to your cluster do the following for each machine:

* SSH to the machine (node1 & node2)
* Become root (e.g. sudo su -)
* Run the command that was output by kubeadm init. For example:

```bash
kubeadm join --token <token> <control-plane-host>:<control-plane-port> --discovery-token-ca-cert-hash sha256:<hash>
```

Verify
```bash
kubectl get nodes
```

## (Optional) Proxying API Server to localhost
If you want to connect to the API Server from outside the cluster you can use kubectl proxy:

```bash
scp root@<control-plane-host>:/etc/kubernetes/admin.conf .
kubectl --kubeconfig ./admin.conf proxy
```

You can now access the API Server locally at http://localhost:8001/api/v1
