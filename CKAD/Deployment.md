# Deployment

Examples

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
kubectl run beta-apps --image=nginx --replicas=3 --dry-run -o yaml > beta.yml

vi beta.yml
```

Generate Deployment YAML file (-o yaml). Don't create it(--dry-run) with 4 Replicas (--replicas=4)

```bash
kubectl create deployment --image=nginx my-webapp --dry-run -o yaml > my-webapp.yaml

kubectl expose deployment my-webapp --type=NodePort --port=80 --name=front-end-service --dry-run -o yaml > front-end-service.yaml
```

```bash
kubectl create deployment webapp --image=kodekloud/webapp-color

kubectl scale deployment/webapp --replicas=3
kubectl scale --replicas=3 deploy webapp

kubectl get deploy

kubectl expose deployment webapp --type=NodePort --port=8080 --name=webapp-service --dry-run -o yaml > webapp-service.yaml
```

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: myapp-deployment
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

---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
  labels:
    app: nginx
spec:
  replicas: 3
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
        - name: nginx
          image: nginx:1.7.9
          ports:
            - containerPort: 80
```

```yaml
# Deployment
apiVersion: apps/v1 # for versions before 1.9.0 use apps/v1beta2
kind: Deployment
metadata:
  name: mysql
  labels:
    app: wordpress
spec:
  selector:
    matchLabels:
      app: wordpress
      tier: mysql
  strategy:
    type: Recreate
  template:
    metadata:
      labels:
        app: wordpress
        tier: mysql
    spec:
      containers:
        - image: mysql:5.7
          name: mysql
          env:
            - name: MYSQL_ROOT_PASSWORD
              valueFrom:
                secretKeyRef:
                  name: mysql-pass
                  key: password
          ports:
            - containerPort: 3306
              name: mysql
          volumeMounts:
            - name: mysql-persistent-storage
              mountPath: "/var/lib/mysql"
      volumes:
        - name: mysql-persistent-storage
          persistentVolumeClaim:
            claimName: mysql-persistent-storage
```

```yaml
# Deployment
apiVersion: apps/v1 # for versions before 1.9.0 use apps/v1beta2
kind: Deployment
metadata:
  name: wordpress
  labels:
    app: wordpress
spec:
  replicas: 2
  selector:
    matchLabels:
      app: wordpress
      tier: frontend
  strategy:
    type: Recreate
  template:
    metadata:
      labels:
        app: wordpress
        tier: frontend
    spec:
      containers:
        - image: wordpress
          name: wordpress
          env:
            - name: WORDPRESS_DB_HOST
              value: wordpress-mysql
            - name: WORDPRESS_DB_PASSWORD
              valueFrom:
                secretKeyRef:
                  name: mysql-pass
                  key: password
          ports:
            - containerPort: 80
              name: wordpress
          volumeMounts:
            - name: wordpress-persistent-storage
              mountPath: "/var/www/html"
      volumes:
        - name: wordpress-persistent-storage
          persistentVolumeClaim:
            claimName: wordpress-persistent-storage
```