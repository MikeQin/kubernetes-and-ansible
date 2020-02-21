# RKE Custom Cluster

```bash
docker run -d --privileged --restart=unless-stopped --net=host -v /etc/kubernetes:/etc/kubernetes -v /var/run:/var/run rancher/rancher-agent:v2.4.0-alpha1 --server https://192.168.56.3 --token 5rtb9jbwbrbw2w64srt9rvm7tcg9pw4dp6pfw62chtnsp8lvm9qp4b --ca-checksum f5f3599e03df28b384f184c977b29f5b6e295a39b95d15deed03356d03d8290d --etcd --controlplane --worker
```