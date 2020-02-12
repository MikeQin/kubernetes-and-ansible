# Resource

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: webapp
spec:
  containers:
    - name: webapp
      image: webapp
      resources:
        requests:
          memory: "1Gi" # default: 256Mi
          cpu: 1 # default: 0.5
        limits:
          memory: "2Gi"
          cpu: 2
```
