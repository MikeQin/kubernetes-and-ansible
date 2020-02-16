# Taints - Node, & Tolerations - PODs

## Taints - Node

```bash
kubectl taint nodes node-name key=value:taint-effect

kubectl taint nodes node1 app=blue:NoSchedule
```

taint-effect:

- NoSchedule
- PreferNoSchedule
- NoExecute

```bash
kubectl taint nodes node1 app=blue:NoSchedule
```

## Tolerations - PODs

```yaml
apiVersion: v1
kind: Pod
spec:
  containers:
    - name: nginx-container
      image: nginx
  tolerations:
    - key: "app"
      operator: "Equal"
      value: "blue"
      effect: "NoSchedule"
```

## Master Node is Tainted

```bash
kubectl describe node kubemaster | grep Taint
```
