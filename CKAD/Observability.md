# Observability

## Readiness Probe

WebApp

```yaml
kind: Pod
spec:
  containers:
  - name: webapp
    image: webapp
    readinessProbe:
      httpGet:
        path: /api/ready
        port: 8080
      initialDelaySeconds: 10
      # How often to probe
      periodSeconds: 5
      # How many attempts
      failureThreshold: 8
```

Database

```yaml
kind: Pod
spec:
  containers:
  - name: mysql
    image: mysql
    readinessProbe:
      tcpSocket:
        port: 3306
```

Shell Script

```yaml
kind: Pod
spec:
  containers:
  - name: busybox
    image: busybox
    readinessProbe:
      exec:
        command:
          - cat
          - /app/is_ready
```

## Liveness Probe

WebApp

```yaml
kind: Pod
spec:
  containers:
  - name: webapp
    image: webapp
    livenessProbe:
      httpGet:
        path: /api/health
        port: 8080
      initialDelaySeconds: 10
      # How often to probe
      periodSeconds: 5
      # How many attempts
      failureThreshold: 8
```

Database

```yaml
kind: Pod
spec:
  containers:
  - name: mysql
    image: mysql
    livenessProbe:
      tcpSocket:
        port: 3306
```

Shell Script

```yaml
kind: Pod
spec:
  containers:
  - name: busybox
    image: busybox
    livenessProbe:
      exec:
        command:
          - cat
          - /app/is_healthy
```

## Logs

```bash
# for multi-containers
kubectl logs -f event-stream-pod-name event-stream-container-name
```

## Monitor - Metrics Server (in-memory)

```bash
# Get
git clone https://github.com/kubernetes-incubator/metrics-server
# Deploy
kubectl create -f deploy/1.8+/

# OR:
git clone https://github.com/kodekloudhub/kubernetes-metrics-server.git
## Deploy all
kubectl create -f .

# View
kubectl top node

kubectl top pod
```


