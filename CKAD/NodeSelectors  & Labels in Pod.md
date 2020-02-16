# Node Selectors

## Label Nodes

```
kubectl label nodes <node-name> <label-key>=<label-value>

kubectl label nodes node1 size=Large

kubectl label nodes node02 app_type=beta
kubectl get nodes node02 --show-labels
```

```yaml
apiVersion: v1
kind: Pod
spec:
  containers:
    - name: data-processor
      image: data-processor
  nodeSelector:
    size: Large
```