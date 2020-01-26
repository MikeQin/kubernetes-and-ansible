# Deploy `nginx`

### Create `nginx` deployment
1) Create a Deployment based on the YAML file:
```
kubectl apply -f https://k8s.io/examples/application/deployment.yaml
```

2) Display information about the Deployment:
```
kubectl describe deployment nginx-deployment
```

The output is similar to this:
```
user@computer:~/website$ kubectl describe deployment nginx-deployment
Name:     nginx-deployment
Namespace:    default
CreationTimestamp:  Tue, 30 Aug 2016 18:11:37 -0700
Labels:     app=nginx
Annotations:    deployment.kubernetes.io/revision=1
Selector:   app=nginx
Replicas:   2 desired | 2 updated | 2 total | 2 available | 0 unavailable
StrategyType:   RollingUpdate
MinReadySeconds:  0
RollingUpdateStrategy:  1 max unavailable, 1 max surge
Pod Template:
  Labels:       app=nginx
  Containers:
   nginx:
    Image:              nginx:1.7.9
    Port:               80/TCP
    Environment:        <none>
    Mounts:             <none>
  Volumes:              <none>
Conditions:
  Type          Status  Reason
  ----          ------  ------
  Available     True    MinimumReplicasAvailable
  Progressing   True    NewReplicaSetAvailable
OldReplicaSets:   <none>
NewReplicaSet:    nginx-deployment-1771418926 (2/2 replicas created)
No events.
```

3) List the pods created by the deployment:
```
kubectl get pods -l app=nginx
```

The output is similar to this:
```
NAME                                READY     STATUS    RESTARTS   AGE
nginx-deployment-1771418926-7o5ns   1/1       Running   0          16h
nginx-deployment-1771418926-r18az   1/1       Running   0          16h
```

4) Display information about a pod:
```
kubectl describe pod <pod-name>
```

where `<pod-name>` is the name of one of your pods.

5) Expose the Service

```
kubectl expose deployment nginx-deployment --type=NodePort --name=mynginx
```