## 1.

Create a Deployment with image `nginx`, `2` replicas, expose it on port `80`
Create a ConfigMap named `zoo-config` with data: `animal: monkey` and `animal: tigr`
Mount the ocnfig map to the deployment on path /tmp/zoo

## 2

Create a StatefullSet named `zoo-app` with image `nginx`, `1` replica, expose it on port `80` with Service type `NodePort`
Create a PersistentVolume with size 1Gi, mount it to the StatefullSet on path `/tmp/zoo-pv`
Change PersistentVolume size to 2Gi
Change mout path to  `/tmp/zoo-pv-2`


## 3

Create a NetworkPolicy which only allows ingress on port 80 for pods with label `app: nginx`

## 4

Create a ServiceAccount `zoo-sa`, create a Role `zoo-role`, bound the role with the ServiceAccount
Create a pod named `zoo-pod` with image `nginx`, expose port `80` in its container and name it `http`, specify the ServiceAccount in this pod.
