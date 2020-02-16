# PersistentVolume

```yaml
apiVersion: v1
kind: PersistentVolume
metadata:
  name: custom-volume
spec:
  accessModes:
  - ReadWriteMany
  capacity:
    storage: 50Mi
  hostPath:
    path: /opt/data
  # Retain (default) | Delete | Recycle
  persistentVolumeReclaimPolicy: Retain
```

```yaml
apiVersion: v1
kind: PersistentVolume
metadata:
  name: pv-vol1
spec:
  accessModes:
    - ReadWriteOnce # ReadOnlyMany | ReadWriteOnce | ReadWriteMany
  capacity:
    storage: 1Gi
  hostPath:
    path: /tmp/data
  #awsElasticBlockStore:
  # volumeID: <volume-id>
  # fsType: ext4

---
# Create PersistentVolume
# change the ip of NFS server
apiVersion: v1
kind: PersistentVolume
metadata:
  name: wordpress-persistent-storage
  labels:
    app: wordpress
    tier: frontend
spec:
  capacity:
    storage: 1Gi
  accessModes:
    - ReadWriteMany
  nfs:
    server: nfs01
    # Exported path of your NFS server
    path: "/html"

---
apiVersion: v1
kind: PersistentVolume
metadata:
  name: mysql-persistent-storage
  labels:
    app: wordpress
    tier: mysql
spec:
  capacity:
    storage: 1Gi
  accessModes:
    - ReadWriteMany
  nfs:
    server: nfs01
    # Exported path of your NFS server
    path: "/mysql"
```