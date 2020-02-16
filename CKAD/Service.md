# Service

- webapp-service.yaml

```
kubectl expose deployment redis --port=6379 --name messaging-service --namespace marketing
```

```yaml
apiVersion: v1
kind: Service
metadata:
  name: messaging-service
  namespace: marketing
spec:
  ports:
    - port: 6379
      protocol: TCP
  selector:
    name: redis
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