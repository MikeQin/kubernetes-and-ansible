# Secret

```bash
echo -n "admin" | base64

kubectl create secret generic \
  app-secret --from-literal=DB_HOST=mysql \
    --from-literal=DB_USER=root \
    --from-literal=DB_PASSWORD=passwrd
```

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: mysecret
type: Opaque
data:
  username: YWRtaW4=
  password: MWYyZDFlMmU2N2Rm

---
apiVersion: v1
kind: Secret
metadata:
  name: db-secret-xxdf
type: Opaque
data:
  DB_Host: c3FsMDE=
  DB_User: cm9vdA==
  DB_Password: cGFzc3dvcmQxMjM=
```

Imperative

```bash
kubectl create secret generic
  <secret-name> --from-literal=<key>=<value>

kubectl create secret generic \
  app-secret --from-literal=DB_HOST=mysql
    --from-literal=DB_USER=root
    --from-literal=DB_PASSWORD=passwrd
```

From file

```bash
kubectl create secret generic
  <secret-name> --from-file=<path-to-file>

kubectl create secret generic
  app-secret --from-file=app_secret.properties
```

Declarative Approach

secret-data.yaml

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: app-secret
data:
  DB_Host: mysql
  DB_User: root
  DB_Password: passwrd
```

Encode in Linux

```bash
echo -n 'mysql' | base64

echo -n 'root' | base64

echo -n 'passwrd' | base64
```

secret-data.yaml after encoding

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: app-secret
data:
  DB_Host: bXlzcWw=
  DB_User: cm9vdA==
  DB_Password: cGFzc3dyZA==
```

```bash
kubectl get secrets

kubectl describe secrets

kubectl get secret app-secret -o yaml
```

Decode

```bash
echo -n 'bXlzcWw=' | base64 --decode

echo -n 'cm9vdA==' | base64 --decode

echo -n 'cGFzc3dyZA==' | base64 --decode
```

## Secrets in Pods

```yaml
apiVersion: v1
kind: Pod
metadata:
spec:
  containers:
  - name: simple-webapp-color
    image: simple-webapp-color
    ports:
      - containerPort: 8080
    envFrom:
      - secretRef:
          name: app-secret

## Single View
    env:
      - name: DB_Password
        valueFrom:
          secretKeyRef:
            name: app-secret
            key: DB_Password

# Volume
    volumes:
    - name: app-secret-volume
      secret:
        secretName: app-secret
```