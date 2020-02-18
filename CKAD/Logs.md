## Logs

```bash
kubectl logs <pod-name> | <deploy-name>

kubectl logs e-com-1123 --namespace e-commerce > /opt/outputs/e-com-1123.logs

# for multi-containers
# -f for follow, live streaming
kubectl logs -f <event-stream-pod-name> <event-stream-container-name>

kubectl get po # find the job pod
kubectl logs busybox-ptx58 -f # follow the logs
```
