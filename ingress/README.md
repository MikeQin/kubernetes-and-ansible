# Ingress Load Balancer

### Ingress Controller

- Namespace
- Service Account
- Cluster Role
- Cluster Role Binding
- Config Map
- Secret
- Daemon Set

### Products

- Nginx
- TRAEFIK

### Resource

https://github.com/MikeQin/kubernetes-1/tree/master/yamls/ingress-demo

### Create `haproxy`

- Install `haproxy`

```bash
sudo yum install -y haproxy
```

- Edit configure file

```bash
sudo vim /etc/haproxy/haproxy.cfg

## Delete everything after global default
```

- Append the following to the end of haproxy.cfg

```bash
frontend http_front
  bind *:80
  stats uri /haproxy?stats
  default_backend http_back

backend http_back
  balance roundrobin
  server kube1 <worker-node1-ip>:80
  server kube2 <worker-node2-ip>:80
```

- Another version: haproxy.cfg

```bash
frontend http-in
  bind *:80
  stats uri /haproxy?stats
  default_backend servers

backend servers
  balance roundrobin
  server h0006415 10.157.163.245:80 maxconn 32
  server h0006416 10.157.163.252:80 maxconn 32
  server h0006417 10.157.163.228:80 maxconn 32
```

- Start and enable haproxy service

```bash
sudo systemctl status haproxy

sudo systemctl enable haproxy

sudo systemctl start haproxy

sudo systemctl status haproxy
```

### Install Ingress Controller

- Create namespace and service account

```bash
git clone https://github.com/nginxinc/kubernetes-ingress.git

cd kubernetes-ingress/deployment

kubectl create -f common/ns-and-sa.yaml
```

- Resources:

Installation Doc, https://docs.nginx.com/nginx-ingress-controller/installation/

Set up Nginx Ingress in Kubernetes Bare Metal, https://youtu.be/chwofyGr80c

Kubernetes Ingress Explained Completely For Beginners, https://youtu.be/VicH6KojwCI

- Create a secret with TLS certificate and a key for the default server in NGINX

```bash
kubectl apply -f common/default-server-secret.yaml
```

- Create a config map for customizing NGINX configuration

```bash
kubectl apply -f common/nginx-config.yaml
```

- Configure RBAC

```bash
kubectl apply -f rbac/rbac.yaml
```

- Deploy the Ingress Controller

Create a daemon set instead of a deployment

```bash
kubectl create -f daemon-set/nginx-ingress.yaml
```

- Verify

```bash
kubectl get all -n nginx-ingress
```

### Create App Deployment

- `cd` to this repo directory: `https://github.com/MikeQin/kubernetes-1/tree/master/yamls/ingress-demo`

```bash
# Create deployment
kubectl create -f nginx-deploy-main.yaml

kubectl get all

# Create service, type: ClusterIP (default)
kubectl expose deploy nginx-deploy-main --port 80

kubectl get all
```

### Create Ingress Resource

```bash
kubectl create -f ingress-resource-1.yaml

# Check Ingress Resource created
kubectl get ing

kubectl describe ing ingress-resource-1
```

### Simulate DNS Server

```bash
sudo vim /etc/hosts

# Find haproxy load balancer IP address
10.21.59.249 nginx.example.com
```

### Deploy another App

```bash
kubectl create -f nginx-deploy-blue.yaml
kubectl create -f nginx-deploy-green.yaml

kubectl get all

# Expose services
kubectl expose deploy nginx-deploy-blue --port 80
kubectl expose deploy nginx-deploy-green --port 80

kubectl get all
```

### Deploy new Ingress Resource

```bash
# Remove the old one
kubectl delete ing ingress-resource-1

# Create the new one
kubectl create -f ingress-resource2.yaml

# Get
kubectl get ing

# Describe
kubectl describe ing ingress-resource2
```

### Modify `/etc/hosts`

```bash
sudo vim /etc/hosts

# Find haproxy load balancer IP address
# All point to the same haproxy server but resulting to 3 different apps
10.21.59.249 nginx.example.com
10.21.59.249 blue.nginx.example.com
10.21.59.249 green.nginx.example.com
```
