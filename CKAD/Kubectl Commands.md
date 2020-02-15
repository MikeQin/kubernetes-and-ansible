# Kubectl Commands

Create a new deployment named 'blue' with the NGINX image and 6 replicas

```
kubectl run blue --image=nginx --replicas=6

kubectl exec webapp cat /log/app.log
```