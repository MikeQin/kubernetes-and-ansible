# Kubectl Commands

### Delete Namespaces, Pods, Services, or other Resources, etc.

```
kubectl cluster-info

kubectl delete namespaces demo-namespace --grace-period=0 --force
kubectl delete namespaces cattle-system --grace-period=0 --force

kubectl patch namespace demo-namespace -p '{"metadata":{"finalizers":null}}'
kubectl patch namespace cattle-system -p '{"metadata":{"finalizers":null}}'
```

#### Source
* https://kubernetes.io/docs/tasks/run-application/force-delete-stateful-set-pod/#delete-pods