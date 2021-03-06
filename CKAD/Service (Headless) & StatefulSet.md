# Headless Services

set `clusterIP: None`

- headless-service.yml

```yaml
apiVersion: v1
kind: Service
metadata:
  name: mysql-h
spec:
  ports:
  - port: 3306
  selector:
    app: mysql
  # Headerless: clusterIP=None
  clusterIP: None
  ###########################
```

- pod-definition.yml

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: myapp-pod
  labels:
    app: mysql
spec:
  containers:
  - name: mysql
    image: mysql
  
  # Only in Pod, None in StatefulSet
  subdomain: mysql-h # Match service name above
  hostname: mysql-pod
  ###########################
```

- statefulset-definition.yml

```yaml
apiVersion: apps/v1
kind: StatefulSet # Like a Deployment
metadata:
  name: mysql-statefulset
  labels:
    app: mysql
spec:
  # Use headless service name
  serviceName: mysql-h
  ###########################
  replicas: 3
  matchLabels:
    app: mysql
  template:
    metadata:
      name: myapp-pod
      labels:
        app: mysql
    spec:
      containers:
      - name: mysql
        image: mysql
```