# Cheetsheet

### Tips

- Set `alias`

```bash
alias ll='ls -laF'
alias k='kubectl'
alias kg='kubectl get'
alias kd='kubectl describe'
alias ke='kubectl explain'
alias kr='kubectl run'
alias kc='kubectl create'
alias ka='kubectl apply'
```

- Copy common commands to notepad:

```bash
# set-context
kubectl config set-context mycontext --namespace=default | anynamespace

kubectl config set-context --current --namespace=default | anynamespace

# explain
kubectl explain cronjob.spec.jobTemplate --recursive
kubectl explain job.spec.template.spec --recursive
kubectl explain pod.spec --recursive
```

### Object Creation

```bash
kubectl run nginx --image=nginx (deployment)
kubectl run nginx --image=nginx --restart=Never (pod)
kubectl run nginx --image=nginx --restart=OnFailure (job)
kubectl run nginx --image=nginx --restart=OnFailure --schedule="* * * * *" (cronjob)
```

Pod

```bash
# Pod
kubectl run nginx --image=nginx --restart=Never --port=80 --namespace=myns \
 --command --serviceaccount=mysa --env=HOSTNAME=local --labels=bu=finance,env=dev \
 --requests='cpu=100m,memory=256Mi' --limits='cpu=200m,memory=512Mi' --dry-run -o yaml \
 -- /bin/sh -c 'echo hello world' > pod.yaml
```

Deployment

```bash
# Deployment
kubectl run frontend --image=busybox --replicas=2 --labels=run=load-balancer-example \
 --port=8080 # --dry-run -o yaml > frontend-deployment.yaml

# Service: NodePort
kubectl expose deployment frontend --type=NodePort --name=frontend-service \
 --port=6262 --target-port=8080 --dry-run -o yaml

# Service: ClusterIP
kubectl create service clusterip myservice --tcp=5678:8080 \
 --dry-run -o yaml > myservice.yaml

# Attach serviceaccount to an existing deployment
kubectl set serviceaccount deployment frontend myuser
```

### Linux bash one-liners:

```bash
args: ["-c" "while true;do date >> /var/log/app.txt;sleep 5;done"]
args: [/bin/sh, -c, 'i=0;while true;do echo "$i: $(date)";i=$((i+1));sleep 1;done']

a=10;b=5;if[ $a -le $b ];then echo "a is small";else echo "b is small";fi
```

### Use `grep`

```bash
kubectl describe pods | grep --context=10 annotations:
kubectl describe pods | grep --context=10 Events:
```
