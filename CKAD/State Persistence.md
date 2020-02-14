# State Persistence

## Volumes & Mounts

```yaml
kind: Pod
spec:
  containers:
  - image: alpine
    name: alpine
    volumeMounts:
    - mountPath: /opt # Inside Docker container
      name: data-volume
  
  volumes:
  - name: data-volume
    hostPath:
      path: /data # Host machine path
      type: Directory
    #awsElasticBlockStore:
    # volumeID: <volume-id>
    # fsType: ext4
```

## Persistent Volume (PV)

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
```

```bash
kubectl create -f pv-definition.yml

kubectl get persistentvolume | pv
```

## Persistent Volume Claim (PVC)

- PV in system space
- PVC in user space
- Binding: PV:PVC (1:1)

```yaml
# Binding

# In PV
labels
  name: my-pv

---
# In PVC
selector:
  matchLabels:
    name: my-pv
```

- PVC

```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: my-pvc
spec:
  accessModes:
  - ReadWriteOnce
  resources:
    requests:
      storage: 500Mi
```

```bash
kubectl create -f pvc-definition.yml

kubectl get persistentvolumeclaim

kubectl delete persistentvolumeclaim my-pvc
```

### Using PVCs in PODs

Once you create a PVC use it in a POD definition file by specifying the PVC Claim name under persistentVolumeClaim section in the volumes section like this:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: mypod
spec:
  containers:
    - name: myfrontend
      image: nginx
      volumeMounts:
      - mountPath: "/var/www/html"
        name: mypd
  volumes:
    - name: mypd
      persistentVolumeClaim:
        claimName: myclaim
```

The same is true for ReplicaSets or Deployments. Add this to the pod template section of a Deployment on ReplicaSet.