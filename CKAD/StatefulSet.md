# Stateful Sets

In sequential order when creating Pods. Maintain sticky Id of a Pod

```yaml
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: mysql
  labels:
    app: mysql
spec:
  template:
    metadata:
      labels:
        app: mysql
    spec:
      containers:
      - name: mysql
        image: mysql
  replicas: 3
  selector:
    matchLabels:
      app: mysql
  serviceName: mysql-h
  podManagementPolicy: Parallel # default: OrderedReady
```

```bash
kubectl create -f statefulset-definition.yml

kubectl scale statefulset mysql --replicas=5

kubectl delete statefulset mysql
```