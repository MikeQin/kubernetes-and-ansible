# Pod

Examples

```bash
kubectl run nginx --image=nginx --restart=Never --port=80 --namespace=myns \
 --command --serviceaccount=mysa --env=HOSTNAME=local --labels=bu=finance,env=dev \
 --requests='cpu=100m,memory=256Mi' --limits='cpu=200m,memory=512Mi' --dry-run -o yaml \
 -- /bin/sh -c 'echo hello world' > pod.yaml
```

```bash
kubectl run my-webapp --image=nginx --labels='tier=frontend' --replicas=2
```

Generate POD Manifest YAML file (-o yaml). Don't create it(--dry-run)

```bash
kubectl run --generator=run-pod/v1 nginx --image=nginx --dry-run -o yaml > nginx-pod-definition.yml

kubectl run --generator=run-pod/v1 webapp --image=kodekloud/webapp-color --replicas=3
```

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: myapp-pod
  labels:
    app: myapp
    type: front-end
spec:
  containers:
    - name: nginx-container
      image: nginx

---
apiVersion: v1
kind: Pod
metadata:
  name: myapp-pod
  labels:
    app: myapp
spec:
  containers:
    - name: myapp-container
      image: busybox
      command: ["sh", "-c", "echo Hello Kubernetes! && sleep 3600"]

---
apiVersion: v1
kind: Pod
metadata:
  name: redis
  labels:
    app: myapp
    type: back-end
spec:
  containers:
    - name: redis
      image: redis

```