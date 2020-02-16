# Storage in StatefulSet

- statefulset-definition.yml

```yaml
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: mysql-statefulset
  labels:
    app: mysql
spec:
  # Use headless service name
  serviceName: mysql-h
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
        volumeMounts:
        - mountPath: /var/lib/mysql
          name: data-volume
      volumes:
      - name: data-volume
        persistentVolumeClaim:
          claimName: data-volume
  # volumeClaimTemplates dynamically create PVC -> PV -> SC
  volumeClaimTemplates:
  # pvc-definition here
  - metadata:
      name: data-volume
    spec:
      accessModes:
      - ReadWriteOnce
      storageClassName: google-storage
      resources:
        requests:
          storage: 500Mi
```

- sc-definition.yml (replacing pv-definition.yml)

```yaml
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: google-storage
provisioner: kubernetes.io/gce-pd
parameters:
  type: pd-standard # pd-ssd | pd-standard
  replication-type: none # regional-pd | none
```