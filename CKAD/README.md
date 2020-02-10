# CKAD Certification

### ReplicaSet

```bash
kubectl create -f replcaset-def.yml

kubectl get replicaset

kubectl delete replicaset myapp-replicaset # deletes all underlying pods

kubectl replace -f replicaset-def.yml

kubectl scale --replicas=6 -f replicaset-def.yml # temporary scale-out
kubectl scale --replicas=6 replicaset myapp-replicaset # temporary scale-out
kubectl scale rs myapp-replicaset --replicas=6 
```

### Deployment

```bash
kubectl create -f deployment-def.yml

kubectl get deployments

kubectl get replicaset

kubectl get pods

kubectl get all -o wide
```

### Command Reference

https://kubernetes.io/docs/reference/kubectl/conventions/

#### Create an NGINX Pod

```
kubectl run --generator=run-pod/v1 nginx --image=nginx
```

#### Generate POD Manifest YAML file (-o yaml). Don't create it(--dry-run)

```
kubectl run --generator=run-pod/v1 nginx --image=nginx --dry-run -o yaml
```

#### Create a deployment

```
kubectl create deployment --image=nginx nginx
```

#### Generate Deployment YAML file (-o yaml). Don't create it(--dry-run)

```
kubectl create deployment --image=nginx nginx --dry-run -o yaml
```

#### Generate Deployment YAML file (-o yaml). Don't create it(--dry-run) with 4 Replicas (--replicas=4)

```
kubectl create deployment --image=nginx nginx --dry-run -o yaml > nginx-deployment.yaml
```

#### Save it to a file, make necessary changes to the file (for example, adding more replicas) and then create the deployment.