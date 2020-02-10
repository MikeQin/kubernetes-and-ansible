# CKAD Certification

```bash
kubectl create -f replcaset-def.yml

kubectl get replicaset

kubectl delete replicaset myapp-replicaset # deletes all underlying pods

kubectl replace -f replicaset-def.yml

kubectl scale --replicas=6 -f replicaset-def.yml # temporary scale-out
kubectl scale --replicas=6 replicaset myapp-replicaset # temporary scale-out
kubectl scale rs myapp-replicaset --replicas=6 
```