## 1.

Create namespace named `cka`.
In namespace `cka`, create a Deployment named `office-nginx` with image `nginx`, `3` replicas, expose it on port `80`
In namespace `cka`, create a ConfigMap named `office-config` with data: `employee: monkey` and `age: 22`
Mount the ocnfig map to the deployment on path /tmp/zoo

## 2

In namespace `cka`, create a StatefullSet named `office-app` with image `nginx`, `2` replica, expose it on port `8080` with Service type `NodePort`
In namespace `cka`, create a PersistentVolumeClaim named `office-pv` with size 1Gi, mount it to the StatefullSet on path `/tmp/office`
Change PersistentVolumeClaim size to 3Gi
Change mout path to  `/tmp/office-pv-2`


## 3

In namespace `cka`, create a NetworkPolicy named `app-np` which allows Egress on port 5432 for pods with label `app: tvh-reg`, ingress connections must be allowed only from 143.22.75.0/24 CIDR and port 80.

## 4

In namespace `cka`, create a ServiceAccount `office-sa`, create a Role `office-role` - verbs `create`, `delete`, `list` on `pods`; bound the role with the ServiceAccount
Create a pod named `office-pod` with image `nginx`, expose port `8080` in its container and name it `http`, specify the ServiceAccount in this pod.

## 5

In namespace `cka`, create a Deployment named `my-deploy2` with 2 replicas and image `nginx`, specify podAfinity so that pods of this deployment scheduled on the same nodes.

## 6 

In namespace `cka`, create a DaemonSet named `my-ds2`, make all pods of this DS scheduled on all nodes

## 7 

Add label `disk: ssd` to a node.
In namespace `cka`, create a Deployment named `my-deploy3` with 1 replicas and image `nginx`, specify nodeSelector so that pods scheduled only on nodes with label `disk: ssd`.

## 8

Create a file name secret.txt with the following content:
```
user: admin
port: 5432
db: prod
password: mysupersecretpassword
```
In namespace `cka`, create a Secret from the file above in namespace

## 9

Create CronJob named `my-cj`, image `nginx`, a Job should run every Satturday at 01:30 AM.
Create Secret named `docker-repo-secret` with type `docker-registry`, provide username `vasya` and password `my-docker-pass123`. Use the secret in the CronJob created in previous step.
