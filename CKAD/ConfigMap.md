# ConfigMap

```bash
kubectl create configmap \
  <config-name> --from-literal=<key>=<value>

kubectl create configmap \
  app-config --from-literal=APP_COLOR=blue \
             --from-literal=APP_MODE=prod

kubectl create configmap \
  <config-name> --from-file=<path-to-file>

kubectl create configmap \
  app-config --from-file=app_config.properties
```

config-map.yaml

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: app-config
data:
  APP_COLOR: "blue"
  APP_MODE: "prod"
```

```
kubectl create -f config-map.yaml

kubectl get configmaps

kubectl describe configmaps
```

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: simple-webapp-color
spec:
  containers:
  - name: simple-webapp-color
    image: simple-webapp-color
    ports:
    - containerPort: 8080
    # ENV
    envFrom:
    - configMapRef:
        name: app-config

## OR: Single View
    env:
    - name: APP_COLOR
      valueFrom:
        configMapKeyRef:
          name: app-config
          key: APP_COLOR
# Volume
    volumes:
    - name: app-config-volume
      configMap:
        name: app-config
```