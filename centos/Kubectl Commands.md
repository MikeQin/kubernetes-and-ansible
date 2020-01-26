# Kubectl Commands

### Delete Namespaces, Pods, Services, or other Resources, etc.

```
kubectl delete pods nginx-deployment-54f57cf6bf-2mgm8 --grace-period=0 --force
kubectl delete pods nginx-deployment-54f57cf6bf-bjxtm --grace-period=0 --force
kubectl delete pods redis-deployment-54b5bc78c9-pjdh4 --grace-period=0 --force
kubectl delete pods postgres-deployment-744df87b7c-82mrr --grace-period=0 --force
kubectl delete pods voting-app-deployment-669dccccfb-6fvmd --grace-period=0 --force
kubectl delete pods result-app-deployment-b8f9dc967-pvk79 --grace-period=0 --force

kubectl cluster-info

kubectl delete namespaces demo-namespace --grace-period=0 --force
kubectl delete namespaces cattle-system --grace-period=0 --force

kubectl patch namespace demo-namespace -p '{"metadata":{"finalizers":null}}'
kubectl patch namespace cattle-system -p '{"metadata":{"finalizers":null}}'
```

#### Source
* https://kubernetes.io/docs/tasks/run-application/force-delete-stateful-set-pod/#delete-pods