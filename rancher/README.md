# Rancher for Kubernetes

### Install Rancher

To install and run Rancher, execute the following Docker command on your host:

- Prepare persistent volume

```
sudo mkdir /opt/rancher
sudo chmod 755 /opt/rancher
```

- Install Rancher

```
docker run -d --restart=unless-stopped -p 8080:80 -p 8443:443 -v /opt/rancher:/var/lib/rancher --name rancher rancher/rancher:latest
```

Copy down container id for future removal:

```
# Sample 1
832f820337cb0bab24d05608948bc48a2972fcb97350c5cb247f050b67e50dca

# Sample 2 - Home
Digest: sha256:b5c473fa93552724c3e0a11203ea51449cf1c56de688a9b7d0147aa126fbeb8b
Status: Downloaded newer image for rancher/rancher:latest
bc6d43691b4a9faca1456252c4b8757def6ec269a839a7ff8cf27b628b690558
```

To access the Rancher server UI, open a browser and go to the hostname or address where the container was installed. You will be guided through setting up your first cluster.

```
http://master:8080 OR https://master:8443

Admin user: admin
```

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