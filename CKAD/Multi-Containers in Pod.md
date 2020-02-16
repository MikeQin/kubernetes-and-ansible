# Multi-Container Pods

### Inspect Pod

```bash
kubectl exec -it app cat /log/app.log
```

### Multi-Container Pods

```bash
# Create the first container Pod first
kubectl run --generator=run-pod/v1 multi-pod --image=nginx --dry-run -o yaml > multi-pod.yml

# Add second container to the Pod
vi multi-pod.yml
```

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: multi-pod
  labels:
    app: mutl-pod
spec:
  containers:
  - image: nginx
    name: jupiter
    env:
    - name: type
      value: "planet"
  - image: busybox
    name: europa
    env:
    - name: type
      value: "moon"
    command: ["sleep", "4800"]
```

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: multi-pod
spec:
  containers:
  - image: kodekloud/filebeat-configured
    name: sidecar
    volumeMounts:
    - mountPath: /var/log/event-simulator/
      name: log-volume
  - image: kodekloud/event-simulator
    name: app
    volumeMounts:
    - mountPath: /log
      name: log-volume
```