# Kubernetes Cluster

### Rancher: Create a Kubernetes Cluster from Existing the Nodes (Custom)

* Master (control plance + etcd)
```
docker run -d --privileged --restart=unless-stopped --net=host -v /etc/kubernetes:/etc/kubernetes -v /var/run:/var/run rancher/rancher-agent:v2.3.5 --server https://192.168.56.3 --token csr587g9tdffr4cr5nwlbrl5fzglxzgtzzq2nsbwgztfrmhw8mchsg --ca-checksum 11f3e4610a229904f3cabed94f5ada07917d54ee485c2ae88498696b99852d56 --etcd --controlplane
```

* Workers
```
docker run -d --privileged --restart=unless-stopped --net=host -v /etc/kubernetes:/etc/kubernetes -v /var/run:/var/run rancher/rancher-agent:v2.3.5 --server https://192.168.56.3 --token csr587g9tdffr4cr5nwlbrl5fzglxzgtzzq2nsbwgztfrmhw8mchsg --ca-checksum 11f3e4610a229904f3cabed94f5ada07917d54ee485c2ae88498696b99852d56 --worker
```c

### kubeadm reset

https://kubernetes.io/docs/reference/setup-tools/kubeadm/kubeadm-reset/

```bash
kubeadm reset
```

Output
```bash
[root@master ~]# kubeadm reset
[reset] Reading configuration from the cluster...
[reset] FYI: You can look at this config file with 'kubectl -n kube-system get cm kubeadm-config -oyaml'
[reset] WARNING: Changes made to this host by 'kubeadm init' or 'kubeadm join' will be reverted.
[reset] Are you sure you want to proceed? [y/N]: y
[preflight] Running pre-flight checks
[reset] Removing info for node "master" from the ConfigMap "kubeadm-config" in the "kube-system" Namespace
W0202 00:26:37.757320   17530 removeetcdmember.go:61] [reset] failed to remove etcd member: error syncing endpoints with etc: etcdclient: no available endpoints
.Please manually remove this etcd member using `etcdctl`
[reset] Stopping the kubelet service
[reset] Unmounting mounted directories in "/var/lib/kubelet"
[reset] Deleting contents of config directories: [/etc/kubernetes/manifests /etc/kubernetes/pki]
[reset] Deleting files: [/etc/kubernetes/admin.conf /etc/kubernetes/kubelet.conf /etc/kubernetes/bootstrap-kubelet.conf /etc/kubernetes/controller-manager.conf /etc/kubernetes/scheduler.conf]
[reset] Deleting contents of stateful directories: [/var/lib/etcd /var/lib/kubelet /var/lib/dockershim /var/run/kubernetes /var/lib/cni]

The reset process does not clean CNI configuration. To do so, you must remove /etc/cni/net.d

The reset process does not reset or clean up iptables rules or IPVS tables.
If you wish to reset iptables, you must do so manually by using the "iptables" command.

If your cluster was setup to utilize IPVS, run ipvsadm --clear (or similar)
to reset your system IPVS tables.

The reset process does not clean your kubeconfig files and you must remove them manually.
Please, check the contents of the `$HOME/.kube/config` file.
```
