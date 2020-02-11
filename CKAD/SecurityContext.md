# Security Context

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: web-pod
spec:
  # Pod level
  securityContext:
    runAsUser: 1000
  containers:
    - name: ubuntu
      image: ubuntu
      command: ["sleep", "3600"]
      # Container level
      securityContext:
        runAsUser: 1001
        capabilities:
          add: ["MAC_ADMIN"]
```

```bash
kubectl exec -it ubuntu-sleeper -- date -s '19 APR 2012 11:14:00'
```
