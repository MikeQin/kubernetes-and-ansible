# Service Account

```bash
kubectl create serviceaccount dashboard-sa

kubectl get serviceaccounts

kubectl describe serviceaccount dashboard-sa

# Get token
kubectl describe secret dashboard-sa-token-kbbdm

# Use token as Bearer token to invoke API
curl https://192.168.56.70:6443/api --insecure --header "Authorization: Bearer eyJhbG..."
```

### ServiceAccount In Pod

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: my-dashboard
spec:
  containers:
    - name: my-dashboard
      image: my-dashboard
  serviceAccount: dashboard-sa
  automountServiceAccountToken: false # default: true
```
