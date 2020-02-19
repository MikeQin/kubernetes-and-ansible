# get podIP
kubectl get pods -o yaml | grep -i podip

# curl -k or --insecure
curl -k https://10.244.3.5