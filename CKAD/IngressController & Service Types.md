# IngressController & Service Types

## Service Types

- NodePort
- ClusterIP
- LoadBalancer

### NodePort

```yaml
apiVerson: v1
kind: Service
metadata:
  name: myapp-service
spec:
  type: NodePort
  ports:
    - targetPort: 80
      port: 80 # Mandatory Only*
      nodePort: 30008
  selector: # Labels below
    app: myapp
    type: front-end
```

```bash
kubectl create -f service-definition.yml

kubectl get services

# http://workerNodeAddress:nodePort
curl http://192.168.1.2:30008
```

### ClusterIP

```yaml
apiVerson: v1
kind: Service
metadata:
  name: back-end
spec:
  type: ClusterIP # Default
  ports:
    - targetPort: 80
      port: 80 # Mandatory Only*
  selector: # Labels below
    app: myapp
    type: back-end
```

```bash
kubectl create -f service-definition.yml

kubectl get services
```

### Ingress Networking

#### Ingress Controller - Layer 7 App LoadBalancer

Deploy:

```yaml
# Deployment
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-ingress-controller
  namespace: ingress-space
spec:
  replicas: 1
  selector:
    matchLabels:
      name: nginx-ingress
  template:
    metadata:
      labels:
        name: nginx-ingress
    spec:
      serviceAccountName: nginx-ingress-serviceaccount
      containers:
        - name: nginx-ingress-controller
          image: quay.io/kubernetes-ingress-controller/nginx-ingress-controller:0.21.0
          args:
            - /nginx-ingress-controller
            - --configmap=$(POD_NAMESPACE)/nginx-configuration
          env:
            - name: POD_NAME
              valueFrom:
                fieldRef:
                  fieldPath: metadata.name
            - name: POD_NAMESPACE
              valueFrom:
                fieldRef:
                  fieldPath: metadata.namespace
          ports:
            - name: http
              containerPort: 80
            - name: https
              containerPort: 443
---
# ConfigMap
apiVersion: v1
kind: ConfigMap
metadata:
  name: nginx-configuration
  namespace: ingress-space
---
# Service
apiVersion: v1
kind: Service
metadata:
  name: nginx-ingress
  namespace: ingress-space
spec:
  type: NodePort
  ports:
    - port: 80
      targetPort: 80
      protocol: TCP
      name: http
    - port: 443
      targetPort: 443
      protocol: TCP
      name: https
  selector:
    name: nginx-ingress
---
# Auth: ServiceAccount
# Role ClusterRole RoleBindings
apiVersion: v1
kind: ServiceAccount
metadata:
  name: nginx-ingress-serviceaccount
  namespace: ingress-space
```

```bash
kubectl create namespace ingress-space

kubectl create configmap nginx-configuration --namespace ingress-space

kubectl create serviceaccount ingress-serviceaccount --namespace ingress-space

kubectl get roles, rolebindings --namespace ingress-space
```

`IngressController` Deployment Example:

```yaml
# IngressController
apiVersion: apps/v1
kind: Deployment
metadata:
  name: ingress-controller
  namespace: ingress-space
spec:
  replicas: 1
  selector:
    matchLabels:
      name: nginx-ingress
  template:
    metadata:
      labels:
        name: nginx-ingress
    spec:
      serviceAccountName: ingress-serviceaccount
      containers:
        - name: nginx-ingress-controller
          image: quay.io/kubernetes-ingress-controller/nginx-ingress-controller:0.21.0
          args:
            - /nginx-ingress-controller
            - --configmap=$(POD_NAMESPACE)/nginx-configuration
            - --default-backend-service=app-space/default-http-backend
          env:
            - name: POD_NAME
              valueFrom:
                fieldRef:
                  fieldPath: metadata.name
            - name: POD_NAMESPACE
              valueFrom:
                fieldRef:
                  fieldPath: metadata.namespace
          ports:
            - name: http
              containerPort: 80
            - name: https
              containerPort: 443
---
# Ingress Resource
apiVersion: v1
kind: Service
metadata:
  name: ingress
  namespace: ingress-space
spec:
  type: NodePort
  ports:
    - port: 80
      targetPort: 80
      protocol: TCP
      nodePort: 30080
      name: http
    - port: 443
      targetPort: 443
      protocol: TCP
      name: https
  selector:
    name: nginx-ingress
```

```bash
kubectl expose deployment -n ingress-space ingress-controller --type=NodePort --port=80 --name=ingress --dry-run -o yaml >ingress.yaml
```

```bash
kubectl get roles, rolebindings --namespace ingress-space
```
