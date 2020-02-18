# Scale & Autoscale

Scale the deployment to 5 replicas

```
kubectl scale deploy nginx --replicas=5

kubectl get po
kubectl describe deploy nginx
```

Autoscale the deployment, pods between 5 and 10, targetting CPU utilization at 80%

```
kubectl autoscale deploy nginx --min=5 --max=10 --cpu-percent=80

kubectl get po
kubectl describe deploy nginx
```

Delete the deployment and the horizontal-pod-autoscaler (hpa) you created

```bash
kubectl delete deploy nginx
kubectl delete hpa nginx

#Or
kubectl delete deploy/nginx hpa/nginx
```