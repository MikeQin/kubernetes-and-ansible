# Service

Examples:

```bash
# Deployment
kubectl run frontend --image=busybox --replicas=2 --labels=run=load-balancer-example \
 --port=8080 # --dry-run -o yaml > frontend-deployment.yaml

# Service: NodePort
kubectl expose deployment frontend --type=NodePort --name=frontend-service \
 --port=6262 --target-port=8080 --dry-run -o yaml

# Service: ClusterIP
kubectl create service clusterip myservice --tcp=5678:8080 \
 --dry-run -o yaml > myservice.yaml

# Attach serviceaccount to an existing deployment
kubectl set serviceaccount deployment frontend myuser
```

```bash
kubectl expose deployment my-webapp --name=front-end-service --type=NodePort --target-port=80 --port=80 --dry-run -o yaml > front-end-service.yml

# Then, edit front-end-service.yml to add nodePort: 30083
```

- webapp-service.yaml

```bash
kubectl expose pod redis --port=6379 --name redis-service
```

```bash
kubectl expose deployment redis --port=6379 --name messaging-service --namespace marketing
```

Equivalent to YAML:

```yaml
apiVersion: v1
kind: Service
metadata:
  labels:
    name: redis-pod
  name: messaging-service
  namespace: marketing
spec:
  ports:
  - port: 6379
    protocol: TCP
    targetPort: 6379
  selector:
    name: redis-pod
  type: ClusterIP
```

```yaml
apiVersion: v1
kind: Service
metadata:
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
```

```yaml
apiVersion: v1
kind: Service
metadata:
  name: my-service
spec:
  type: ClusterIP # NodePort | LoadBalancer | default: ClusterIP
  selector:
    app: MyApp
  ports:
    - protocol: TCP
      port: 80
      targetPort: 9376

---
apiVersion: v1
kind: Service
metadata:
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

```

```yaml
# Service
apiVersion: v1
kind: Service
metadata:
  name: wordpress-mysql
  labels:
    app: wordpress
spec:
  ports:
    - port: 3306
  selector:
    app: wordpress
    tier: mysql
  clusterIP: None
```

```yaml
# create a service for wordpress
# Service
apiVersion: v1
kind: Service
metadata:
  name: wordpress
  labels:
    app: wordpress
spec:
  ports:
    - port: 80
      nodePort: 31004
  selector:
    app: wordpress
    tier: frontend
  type: NodePort
```