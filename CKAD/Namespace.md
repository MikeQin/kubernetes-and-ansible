# Namespace

```bash
kubectl get pods --namespace=dev
kubectl get pods --n dev

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