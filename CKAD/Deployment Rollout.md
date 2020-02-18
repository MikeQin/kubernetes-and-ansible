# Pod Design - Deployment Rollout

## Rolling Update & Rollback in Deployment

Strategies:
- Recreate
- RollingUpdate (default)

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: myapp-deployment
  labels:
    app: myapp
    type: front-end
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

# Set Image
# kubectl set image POD/POD_NAME CONTAINER_NAME=IMAGE_NAME:TAG
kubectl set image pod/nginx nginx=nginx:1.7.1
# you will see an event 'Container will be killed and recreated'
kubectl describe po nginx 
kubectl get po nginx -w # watch it

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