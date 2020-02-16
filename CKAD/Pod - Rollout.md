# Pod Design

## Labels, Selectors & Annotations

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: app
  labels:
    app: App1
    function: Front-end
  annotations:
    buildVersion: 1.34
spec:
  containers:
  - name: app
    image: app
    ports:
      - containerPort: 8080
```

```bash
kubectl get pods --selector app=App1

kubectl get pods --selector bu-finance --selector tier=frontend --selector env=prod
```

## Rolling Update & Rollback in Deployment

Strategies:
- Recreate
- RollingUpdate (default)

```yaml
kind: Deployment
spec:
  strategy:
    type: Recreate # Default: RollingUpdate
```

```
kubectl rollout status deployment/myapp-deployment
kubectl rollout status deploy myapp-deployment
```

```bash
kubectl apply -f deploy-def.yml

# Temporary
kubectl set image deploy myapp-deployment nginx-container=nginx:1.9.1
kubectl set image deploy frontend simple-webapp=kodekloud/webapp-color:v3
```

```bash
kubectl rollout undo deployment/myapp-deployment

# See before & after
kubectl get replicasets
```

### Sumarize Commands

```bash
# Create & record revision history
kubectl create -f deployment-definition.yml --record

# Get
kubectl get deployments

# Update
kubectl apply -f deployment-definition.yml
kubectl set image deployment/myapp-deployment nginx-container=nginx:1.9.1

# Status
kubectl rollout status deployment/myapp-deployment
# Revision history
kubectl rollout history deployment/myapp-deployment

# Rollback
kubectl rollout undo deployment/myapp
```