# Taints - Node, & Tolerations - PODs

## Taints - Node

```bash
kubectl taint nodes node-name key=value:taint-effect

kubectl taint nodes node1 app=blue:NoSchedule

kubectl taint nodes node01 app_type=alpha:NoSchedule
```

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: alpha
spec:  
  containers:
    - name: redis      
      image: redis
  tolerations:
    - key: "app_type"
      operator: "Equal"      
      value: "alpha"
      effect: "NoSchedule"
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
metadata:
  name: nginx
spec:
  containers:
    - name: nginx
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
