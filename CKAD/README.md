# CKAD Certification

## Kubernetes Challenges

- Repository: kodekloudhub/kubernetes-challenges
- github: https://github.com/kodekloudhub/kubernetes-challenge-1-wordpress
- Student Video: https://youtu.be/rnemKrveZks

Use Shortcuts / Aliases
- po for PODS
- rs for ReplicaSets
- deploy for Deployments
- svc for Services
- ns for Namespaces
- netpol for NetworkPolicies
- pv for PersistVolumes
- pvc for PersistentVolumeClaims
- sa for ServiceAccounts

### ReplicaSet

```bash
kubectl create -f replcaset-def.yml

kubectl get replicaset

kubectl delete replicaset myapp-replicaset # deletes all underlying pods

kubectl replace -f replicaset-def.yml

kubectl scale --replicas=6 -f replicaset-def.yml # temporary scale-out
kubectl scale --replicas=6 replicaset myapp-replicaset # temporary scale-out
kubectl scale rs myapp-replicaset --replicas=6
```

### Deployment

```bash
kubectl create -f deployment-def.yml

kubectl get deployments

kubectl get replicaset

kubectl get pods

kubectl get all -o wide
```

### Command Reference

https://kubernetes.io/docs/reference/kubectl/conventions/

#### Create an NGINX Pod

```bash
# create Pod only
kubectl run --generator=run-pod/v1 nginx --image=nginx

# create Deploy & Pod
kubectl run nginx --image=nginx
```

#### Generate POD Manifest YAML file (-o yaml). Don't create it(--dry-run)

```bash
kubectl run --generator=run-pod/v1 nginx --image=nginx --dry-run -o yaml
```

#### Create a deployment

```bash
kubectl create deployment --image=nginx nginx
```

#### Generate Deployment YAML file (-o yaml). Don't create it(--dry-run)

```bash
kubectl create deployment --image=nginx nginx --dry-run -o yaml
```

#### Generate Deployment YAML file (-o yaml). Don't create it(--dry-run) with 4 Replicas (--replicas=4)

```bash
kubectl create deployment --image=nginx nginx --dry-run -o yaml > nginx-deployment.yaml
```

#### Save it to a file, make necessary changes to the file (for example, adding more replicas) and then create the deployment.

### Namespace

```bash
kubectl get pods --namespace=dev

# Get
kubectl get ns

# Create
kubectl create namespace dev
```

Pod definition can reference namespace in metadata.

```yaml
apiVersion: v1
metadata:
  name: xyz
  namespace: dev
  ...
```

Define namespace in namespace-dev.yml

```yaml
# namespace-dev.yml
apiVersion: v1
kind: Namespace
metadata:
  name: dev
```

```bash
# Run
kubectl create -f namespace-dev.yml
# OR Run
kubectl create namespace dev
```

Permanently set namespace

```bash
kubectl config set-context $(kubectl config current-context) --namespace=dev

# Get pods without indicating namespace
kubectl get pods

# However for other namespaces, you need to specify the namespace
kubectl get pods --namespace default

# Show all namespaces
kubectl get pods --all-namespace
```

#### DNS

```
[service-name].[namespace].[svc].[cluster.local]
```

Example:

```
db-service.dev.svc.cluster.local
```

#### Example

```bash
kubectl run --generator=run-pod/v1 redis --image=redis:alpine --dry-run -o yaml > redis-def.yaml

vim redis-def.yaml # add label: tier=db

kubectl create -f redis-def.yaml
```

```bash
kubectl expose pod redis --port=6379 --name redis-service

kubectl run --generator=run-pod/v1 webapp --image=kodekloud/webapp-color --replicas=3
```

```bash

kubectl create deployment webapp --image=kodekloud/webapp-color

kubectl scale deployment/webapp --replicas=3
kubectl scale --replicas=3 deploy webapp

kubectl get deploy

kubectl expose deployment webapp --type=NodePort --port=8080 --name=webapp-service --dry-run -o yaml > webapp-service.yaml
```

- webapp-service.yaml

```yaml
apiVersion: v1
kind: Service
metadata:
  creationTimestamp: null
  labels:
    app: webapp
  name: webapp-service
spec:
  ports:
    - port: 8080
      protocol: TCP
      targetPort: 8080
      nodePort: 30082 # Add nodePort here
  selector:
    app: webapp
  type: NodePort
status:
  loadBalancer: {}
```

### ResourceQuota

```yaml
apiVersion: v1
kind: ResourceQuota
metadata:
  name: compute-quota
  namespace: dev
spec:
  hard:
    pods: "9"
    requests.cpu: "4"
    requests.memory: 5Gi
    limits.cpu: "8"
    limits.memory: 10Gi
```
