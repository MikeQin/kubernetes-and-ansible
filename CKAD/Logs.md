## Logs

```bash
kubectl logs <pod-name> | <deploy-name>

kubectl logs e-com-1123 --namespace e-commerce > /opt/outputs/e-com-1123.logs

# for multi-containers
# -f for live streaming
kubectl logs -f <event-stream-pod-name> <event-stream-container-name>
```
