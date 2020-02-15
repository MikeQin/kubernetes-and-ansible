# Service

- webapp-service.yaml

```yaml
apiVersion: v1
kind: Service
metadata:
  labels:
    app: webapp
  name: webapp-service
spec:
  ports:
    - port: 8080
      protocol: TCP
      targetPort: 8080
      nodePort: 30082 # Add nodePort here
  selector:
    app: webapp
  type: NodePort
```