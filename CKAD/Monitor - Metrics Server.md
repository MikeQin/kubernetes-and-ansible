## Monitor - Metrics Server (in-memory)

```bash
# Get
git clone https://github.com/kubernetes-incubator/metrics-server
# Deploy
kubectl create -f deploy/1.8+/

# OR:
git clone https://github.com/kodekloudhub/kubernetes-metrics-server.git
## Deploy all
kubectl create -f .

# View
kubectl top node

kubectl top pod
```
