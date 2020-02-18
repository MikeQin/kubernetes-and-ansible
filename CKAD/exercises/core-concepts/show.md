# Core Concepts (13%)

- Create a namespace called 'mynamespace' and a pod with image nginx called nginx on this namespace

```
kubectl create namepsace mynamespace

kubectl run nginx --image-nginx --restart=Never -n mynamespace
```

- Create the pod that was just described using YAML

```
kubectl run nginx --image=nginx --restart=Never --dry-run -o yaml > pod.yaml

cat pod.yaml
```

- Create a busybox pod (using kubectl command) that runs the command "env". Run it and see the output

```
kubectl run busybox --image=busybox --command -- env

kubectl logs busybox
```

- Create a busybox pod (using YAML) that runs the command "env". Run it and see the output

```
kubectl run busybox --image=busybox --dry-run -o yaml --command -- env > envpod.yaml

cat envpod.yaml
```

- Get the YAML for a new namespace called 'myns' without creating it

```
kubectl create namespace myns --dry-run -o yaml
```

- Get the YAML for a new ResourceQuota called 'myrq' with hard limits of 1 CPU, 1G memory and 2 pods without creating it

```
kubectl create quota myrq --hard=cpu=1,memory=1G,pods=2 --dry-run -o yaml
```

- Get pods on all namespaces

```
kubectl get pods --all-namespaces
```

- Create a pod with image nginx called nginx and allow traffic on port 80

```
kubectl run nginx --image=nginx --port=80
```

- Change pod's image to nginx:1.7.1. Observe that the pod will be killed and recreated as soon as the image gets pulled

```bash
# kubectl set image POD/POD_NAME CONTAINER_NAME=IMAGE_NAME:TAG
kubectl set image pod/nginx nginx=nginx:1.7.1
kubectl describe po nginx # you will see an event 'Container will be killed and recreated'
kubectl get po nginx -w # watch it
```

- Get nginx pod's ip created in previous step, use a temp busybox image to wget its '/'

```bash
kubectl get po -o wide # get the IP, will be something like '10.1.1.131'
# create a temp busybox pod
kubectl run busybox --image=busybox --rm -it --restart=Never -- wget -O- 10.1.1.131:80
```

- Get pod's YAML

```bash
kubectl get pod nginx -o yaml > pod.yaml
```

- Get information about the pod, including details about potential issues (e.g. pod hasn't started)

```bash
kubectl describe po nginx
```

- Get pod logs

```
kubectl logs nginx
```

- If pod crashed and restarted, get logs about the previous instance

```
kubectl logs nginx -p
```

- Execute a simple shell on the nginx pod

```
kubectl exec -it nginx -- /bin/sh
```

- Create a busybox pod that echoes 'hello world' and then exits

```bash
kubectl run busybox --image=busybox -it --restart=Never -- echo "hello world"
```

- Do the same, but have the pod deleted automatically when it's completed

```
kubectl run busybox --image=busybox --rm -it --restart=Never -- echo "hello world"
```

- Create an nginx pod and set an env value as 'var1=val1'. Check the env value existence within the pod

```
kubectl run nginx --image=nginx --restart=Never --env=var1=val1

kubectl exec -it nginx -- env
```