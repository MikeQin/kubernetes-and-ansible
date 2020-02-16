# Observability

Readiness n Liveness

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

