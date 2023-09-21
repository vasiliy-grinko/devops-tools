## 1.

Create a Deployment named `my-nginx` with image `nginx`, `3` replicas, expose it on port `80`
Create a ConfigMap named `zoo-config` with data: `animal: monkey` and `animal: tigr`
Mount the ocnfig map to the deployment on path /tmp/zoo

## 2

Create a StatefullSet named `zoo-app` with image `nginx`, `2` replica, expose it on port `8080` with Service type `NodePort`
Create a PersistentVolumeClaim named `zoo-pv` with size 1Gi, mount it to the StatefullSet on path `/tmp/zoo`
Change PersistentVolumeClaim size to 2Gi
Change mout path to  `/tmp/zoo-pv-2`


## 3

Create a NetworkPolicy which allows ingress on port 5432 for pods with label `app: nginx`, ingress connections must be allowed only from 173.22.55.0/24 CIDR.

## 4

Create a ServiceAccount `zoo-sa`, create a Role `zoo-role`, bound the role with the ServiceAccount
Create a pod named `zoo-pod` with image `nginx`, expose port `80` in its container and name it `http`, specify the ServiceAccount in this pod.

## 5

Create a Deployment named `my-deploy` with 2 replicas, specify anti afinity so that pods of this deployment scheduled on differenet nodes.

## 6 

 Create a DaemonSet named `my-ds`, make all pods of this DS scheduled on all nodes
