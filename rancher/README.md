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
docker run -d --restart=unless-stopped -p 8000:80 -p 8443:443 -v /opt/rancher:/var/lib/rancher --name rancher rancher/rancher:latest
```

Copy down container id for future removal:

```
832f820337cb0bab24d05608948bc48a2972fcb97350c5cb247f050b67e50dca
```

To access the Rancher server UI, open a browser and go to the hostname or address where the container was installed. You will be guided through setting up your first cluster.

### Add Cluster - Import

Run the kubectl command below on an existing Kubernetes cluster running a supported Kubernetes version to import it into Rancher:

```
curl --insecure -sfL https://master:8443/v3/import/qcqjcwmggp9lzjpt6k8nw788gmhr9zqwhj2vcwqpdfz4gxq6t4p9fv.yaml | kubectl apply -f -
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
