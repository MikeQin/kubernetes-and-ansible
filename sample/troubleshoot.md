# Troubleshooting CentOS 8 in VirtualBox

### Master

```bash
# Describe
kubectl describe pod pod-name

# Log
kubectl logs pod-name

# from node to master
curl -v -insecure https://192.168.56.100:6443/api/v1/nodes/foo

# Check this file
ll /run/flannel/subnet.env
-rw-r--r--. 1 root root 96 Jan 28 03:26 /run/flannel/subnet.env

# Change owner
sudo chown $(id -u):$(id -g) /run/flannel/subnet.env

# Content
sudo cat /run/flannel/subnet.env
FLANNEL_NETWORK=10.244.0.0/16
FLANNEL_SUBNET=10.244.0.1/24
FLANNEL_MTU=1450
FLANNEL_IPMASQ=true
```