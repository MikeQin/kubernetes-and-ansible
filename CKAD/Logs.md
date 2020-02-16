## Logs

```bash
kubectl logs <pod-name> | <deploy-name>

# for multi-containers
# -f for live streaming
kubectl logs -f <event-stream-pod-name> <event-stream-container-name>
```
