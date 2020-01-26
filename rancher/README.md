# Rancher for Kubernetes

### Install `docker` first
See instructions for installing `docker`.

### Disable `worker-node` firewall permanently on CentOS
Firewall on CentOS is enabled by default. We need to disable it to make the Kube cluster work. See intructions.

### Install `kubectl` using package manager

* Install Guide, https://kubernetes.io/docs/tasks/tools/install-kubectl/#install-kubectl-on-linux

```bash
# As a root user first
sudo su

# Set up repo
cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF

# Install
yum install -y kubectl

# Exit root
exit

# Test to ensure the version you installed is up-to-date
kubectl version --client
```

### Install Rancher

To install and run Rancher, execute the following Docker command on your host:

* Prepare persistent volume

```bash
sudo mkdir /opt/rancher
```

* Make copy of `.kube/config` from Kubernetes cluster's master-node
```bash
# Rancher node
mkdir ~/.kube

# Copy the kube cluster config to Rancher node
scp root@master:/etc/kubernetes/admin.conf ~/.kube/config
```

* Check cluster status
```
kubectl cluster-info

kubectl get nodes

kubectl version --short
```

* Install Rancher

```bash
docker run -d --restart=unless-stopped -p 80:80 -p 443:443 -v /opt/rancher:/var/lib/rancher --name rancher rancher/rancher:latest

# Container name: rancher
# Persistent volume: /opt/rancher
```

* Check logs for errors
```bash
docker logs -f rancher
```

* Verify the Rancher can connect to the cluster

** cattle-node-agent
```bash
# Check if the cattle-node-agent pods are present on each node, have status Running and don’t have a high count of Restarts:
kubectl -n cattle-system get pods -l app=cattle-agent -o wide

# Check logging of a specific cattle-node-agent pod or all cattle-node-agent pods:
kubectl -n cattle-system logs -l app=cattle-agent
```

** cattle-cluster-agent

```bash
# Check if the cattle-cluster-agent pod is present in the cluster, has status Running and doesn’t have a high count of Restarts:
kubectl -n cattle-system get pods -l app=cattle-cluster-agent -o wide

# Check logging of cattle-cluster-agent pod:
kubectl -n cattle-system logs -l app=cattle-cluster-agent
```

* To access the Rancher server UI, open a browser and go to the hostname or address where the container was installed. You will be guided through setting up your first cluster.
If you run Rancher and K8s Cluster on local environment with VirtualBox VMs, you must set `server-url` to be the Rancher node's `ip address`, for example:

```bash
# server-url
https://192.168.56.3

# username: admin
```

Note, that Rancher uses DNS Service to resolve hostname, therefore, configuring `/etc/hosts` will not help. You must use `ip address` for running it locally.

### Add Cluster - Import

* Run the kubectl command below on an existing Kubernetes cluster running a supported Kubernetes version to import it into Rancher:

```
# Sample 1
curl --insecure -sfL https://master:8443/v3/import/qcqjcwmggp9lzjpt6k8nw788gmhr9zqwhj2vcwqpdfz4gxq6t4p9fv.yaml | kubectl apply -f -

# Sample 2 - Home
curl --insecure -sfL https://master:8443/v3/import/w8tfj4xs7nwd622g5bcjvbtmhvc985q8c7glgkz6c69h9626t5bb64.yaml | kubectl apply -f -
```

### Reference

- Rancher Quick Start, https://rancher.com/quick-start/
- Rancher Quick Start Guide, https://rancher.com/docs/rancher/v2.x/en/quick-start-guide/

- Some `kubectl` commands:

```
kubectl version --short

watch kubectl get namespaces

watch kubectl -n cattle-system get all -o wide

watch kubectl get all -o wide
```

- Manual Quick Start, https://rancher.com/docs/rancher/v2.x/en/quick-start-guide/deployment/quickstart-manual-setup/
- Adding Ingresses to Your Project, https://rancher.com/docs/rancher/v2.x/en/k8s-in-rancher/load-balancers-and-ingress/ingress/

## Create a new Kubernetes Cluster from Rancher

```
sudo docker run -d --privileged --restart=unless-stopped --net=host -v /etc/kubernetes:/etc/kubernetes -v /var/run:/var/run rancher/rancher-agent:v2.3.4 --server https://master:8443 --token xgdhnpqvxsh4cmj9t5s4wtkgfrh5qz8v5zhpj2qhmrmvgmdfvctvll --ca-checksum 7902375b8b50ceaeec92d0980e4635d24be0f463e3e5bc2e3f5b49a460446bbb --etcd --controlplane --worker
```

## Deploy a Sample App

* example-voting-app-kubernetes-v2, https://github.com/MikeQin/example-voting-app-kubernetes-v2.git