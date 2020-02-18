# Labels & Annotations

## Pod Labels

```bash
kubectl get pods --selector app=App1
# OR
kubectl get pods -l app=App1

kubectl get pods --selector bu-finance --selector tier=frontend --selector env=prod
```

Show all labels of the pods

```
kubectl get pods --show-labels
```

Change the labels of pod 'nginx2' to be app=v2

```
kubectl label po nginx2 app=v2 --overwrite
```

Get the label 'app' for the pods

```bash
kubectl get po -L app
# or
kubectl get po --label-columns=app
```

Get only the 'app=v2' pods

```bash
kubectl get po -l app=v2
# or
kubectl get po -l 'app in (v2)'
# or
kubectl get po --selector=app=v2
```

Remove the 'app' label from the pods we created before

```bash
kubectl label po nginx1 nginx2 nginx3 app-
# or
kubectl label po nginx{1..3} app-
# or
kubectl label po -lapp app-
```

Create a pod that will be deployed to a Node that has the label 'accelerator=nvidia-tesla-p100'

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: cuda-test
spec:
  containers:
    - name: cuda-test
      image: "k8s.gcr.io/cuda-vector-add:v0.1"
  nodeSelector: # add this
    accelerator: nvidia-tesla-p100 # the selection label
```

## Pod Annotation

Annotate pods nginx1, nginx2, nginx3 with "description='my description'" value

```bash
kubectl annotate po nginx1 nginx2 nginx3 description='my description'
#or
kubectl annotate po nginx{1..3} description='my description'
```

Check the annotations for pod nginx1

```bash
kubectl describe po nginx1 | grep -i 'annotations'
```

Remove the annotations for these three pods

```bash
kubectl annotate po nginx1 nginx2 nginx3 description-

kubectl annotate po nginx{1..3} description-
```

Remove these pods to have a clean state in your cluster

```bash
kubectl delete po nginx{1..3}
```

## Label Nodes

```
kubectl label nodes <node-name> <label-key>=<label-value>

kubectl label nodes node1 size=Large

kubectl label nodes node02 app_type=beta
kubectl get nodes node02 --show-labels
```

```yaml
apiVersion: v1
kind: Pod
spec:
  containers:
    - name: data-processor
      image: data-processor
  nodeSelector:
    size: Large
```