# PersistentVolumeClaim

```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: mysql-persistent-storage
  labels:
    app: wordpress
spec:
  accessModes:
    - ReadWriteMany
  resources:
    requests:
      storage: 1Gi
  volumeName: "mysql-persistent-storage"

---
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: wordpress-persistent-storage
  labels:
    app: wordpress
spec:
  accessModes:
    - ReadWriteMany
  resources:
    requests:
      storage: 1Gi
  volumeName: "wordpress-persistent-storage"
```