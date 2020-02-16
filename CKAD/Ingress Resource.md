# Ingress Resource

Must be created in `app-space` or `default`, not in `ingress-space`

### Commands

```bash
kubectl create -f ingress-wear.yaml

kubectl get ingress
kubectl get ingress -n app-space
kubectl get ingress --all-namespaces

kubectl edit ingress test-ingress
kubectl describe ingress test-ingress
```

```bash
kubectl describe ingress ingress-wear-watch

kubectl edit ingress --namespace app-space
```

### YAML Examples

```yaml
apiVersion: networking.k8s.io/v1beta1
kind: Ingress
metadata:
  name: test-ingress
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /
spec:
  rules:
  - http:
      paths:
      - path: /testpath
        backend:
          serviceName: test
          servicePort: 80

---
apiVersion: networking.k8s.io/v1beta1
kind: Ingress
metadata:
  name: simple-fanout-example
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /
spec:
  rules:
  - host: foo.bar.com
    http:
      paths:
      - path: /foo
        backend:
          serviceName: service1
          servicePort: 4200
      - path: /bar
        backend:
          serviceName: service2
          servicePort: 8080

---
apiVersion: networking.k8s.io/v1beta1
kind: Ingress
metadata:
  name: name-virtual-host-ingress
spec:
  rules:
  - host: foo.bar.com
    http:
      paths:
      - backend:
          serviceName: service1
          servicePort: 80
  - host: bar.foo.com
    http:
      paths:
      - backend:
          serviceName: service2
          servicePort: 80

---
apiVersion: networking.k8s.io/v1beta1
kind: Ingress
metadata:
  name: name-virtual-host-ingress
spec:
  rules:
  - host: first.bar.com
    http:
      paths:
      - backend:
          serviceName: service1
          servicePort: 80
  - host: second.foo.com
    http:
      paths:
      - backend:
          serviceName: service2
          servicePort: 80
  - http:
      paths:
      - backend:
          serviceName: service3
          servicePort: 80
```

Create a new Ingress Resource for the service: `my-video-service` to be made available at the URL: http://ckad-mock-exam-solution.com:30093/video

Check VERSION
```bash
kubectl explain ingress --recursive | grep VERSION

VERSION: extensions/v1beta1
```

```yaml
# networking.k8s.io/v1beta1
apiVersion: extensions/v1beta1 # extensions/v1beta1
kind: Ingress
metadata:
  name: my-ingress
  #annotations:
  #  nginx.ingress.kubernetes.io/rewrite-target: /
spec:
  rules:
  - host: ckad-mock-exam-solution.com
    http:
      paths:
      - path: /video
        backend:
          serviceName: my-video-service
          # Service Port
          servicePort: 8080
```

### Single Service Ingress

Configure `ingress-wear.yaml`

```yaml
apiVersion: networking.k8s.io/v1beta1
kind: Ingress
metadata:
  name: ingress-wear
  namespace: app-space
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /
    nginx.ingress.kubernetes.io/ssl-redirect: "false"
spec:
  backend:
    serviceName: wear-service
    servicePort: 80
```

### Simple Fanout

Ingress Resource: `ingress-wear-watch.yml`

```yaml
apiVersion: networking.k8s.io/v1beta1
kind: Ingress
metadata:
  name: ingress-wear-watch
  namespace: app-space
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /
    nginx.ingress.kubernetes.io/ssl-redirect: "false"
spec:
  rules:
  - http:
      paths:
      - path: /wear
        backend:
          serviceName: wear-service
          servicePort: 8080
      - path: /watch
        backend:
          serviceName: video-service
          servicePort: 8080
```

### Name Based Virtual Hosting

```yaml
apiVersion: networking.k8s.io/v1beta1
kind: Ingress
metadata:
  name: ingress-wear-watch
  namespace: critical-space 
spec:
  rules:
  - host: wear.onlinestore.com
    http:
      paths:
      - backend:
          serviceName: wear-service
          servicePort: 80
  - host: watch.onlinestore.com
    http:
      paths:          
      - backend:
          serviceName: watch-service
          servicePort: 80
```

### `rewrite-target` Option

For example: `replace(path, rewrite-target)`

In our case: `replace("/path","/")`

```yaml
apiVersion: networking.k8s.io/v1beta1
kind: Ingress
metadata:
  name: test-ingress
  namespace: critical-space
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /
spec:
  rules:
  - http:
      paths:
      - path: /pay
        backend:
          serviceName: pay-service
          servicePort: 8282
```

In another example given here, this could also be:

`replace("/something(/|$)(.*)", "/$2")`

```yaml
apiVersion: networking.k8s.io/v1beta1
kind: Ingress
metadata:
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /$2
  name: rewrite
  namespace: default
spec:
  rules:
  - host: rewrite.bar.com
    http:
      paths:
      - backend:
          serviceName: http-svc
          servicePort: 80
        path: /something(/|$)(.*)
```