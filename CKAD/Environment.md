# Environment

Create an nginx pod and set an env value as 'var1=val1'. Check the env value existence within the pod

```bash
kubectl run nginx --image=nginx --restart=Never --env=var1=val1

kubectl exec -it nginx -- env
```

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: envar-demo
  labels:
    purpose: demonstrate-envars
spec:
  containers:
  - name: envar-demo-container
    image: gcr.io/google-samples/node-hello:1.0
    env:
    - name: DEMO_GREETING
      value: "Hello from the environment"
    - name: DEMO_FAREWELL
      value: "Such a sweet sorrow"
```