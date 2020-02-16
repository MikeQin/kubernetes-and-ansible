# ReplicaSet

```bash
kubectl create -f replcaset-def.yml

kubectl get replicaset

kubectl delete replicaset myapp-replicaset # deletes all underlying pods

kubectl replace -f replicaset-def.yml

# replicaset = rs
kubectl scale --replicas=6 -f replicaset-def.yml # temporary scale-out
kubectl scale --replicas=6 replicaset myapp-replicaset # temporary scale-out
kubectl scale rs myapp-replicaset --replicas=6
```

```yaml
apiVersion: apps/v1
kind: ReplicaSet
metadata:
  name: myapp-replicaset
  labels:
    app: myapp
    type: front-end
spec:
  replicas: 3
  selector:
    matchLabels:
      app: myapp
      type: front-end
  template:
    metadata:
      name: myapp-pod
      labels:
        app: myapp
        type: front-end
    spec:
      containers:
        - name: nginx-container
          image: nginx
```