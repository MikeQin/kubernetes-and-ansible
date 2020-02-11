# Node Affinity

```yaml
apiVersion: v1
kind: Pod
spec:
  containers:
    - name: data-processor
      image: data-processor
  affinity:
    nodeAffinity:
      requiredDuringSchedulingIgnoredDuringExecution:
        # preferredDuringSchedulingIgnoredDuringExecution:
        nodeSelectorTerms:
          - matchExpression:
              - key: size
                operator: In # NotIn | In | Exists
                values:
                  - Large
```

Node Affinity Types:

- requiredDuringSchedulingIgnoredDuringExecution
- preferredDuringSchedulingIgnoredDuringExecution

Planned:

- requiredDuringSchedulingRequiredDuringExecution:
