# Taints - Node, & Tolerations - PODs

## Taints - Node

```
kubectl taint nodes node-name key=value:taint-effect
```

taint-effect:

- NoSchedule
- PreferNoSchedule
- NoExecute

```
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

```
kubectl describe node kubemaster | grep Taint
```
