#! /bin/bash

echo
echo "[ Install epel-release ]"
echo "========================"
dnf install epel-release -y

echo
echo "[ Install Ansible ]"
echo "==================="
dnf install ansible -y
echo
ansible --version

echo
echo "[ Install sshpass ]"
echo "==================="
dnf install sshpass -y

echo
echo "[ ssh-keygen && ssh-copy-id ]"
echo "============================="
ssh-keygen -t rsa -b 4096 -N "" -C "auto key" -f /root/.ssh/id_rsa
sshpass -p password ssh-copy-id -o StrictHostKeyChecking=no root@192.168.218.190
sshpass -p password ssh-copy-id -o StrictHostKeyChecking=no root@192.168.218.191
sshpass -p password ssh-copy-id -o StrictHostKeyChecking=no root@192.168.218.192
sshpass -p password ssh-copy-id -o StrictHostKeyChecking=no root@192.168.218.193
sshpass -p password ssh-copy-id -o StrictHostKeyChecking=no root@192.168.218.194
sshpass -p password ssh-copy-id -o StrictHostKeyChecking=no root@192.168.218.195

echo
echo "[ Install git ]"
echo "==============="
dnf install git -y

echo
echo "[ Kubespray ]"
echo "============="
git clone https://github.com/kubernetes-sigs/kubespray.git
cp -r kubespray/inventory/sample kubespray/inventory/cluster-5
cd kubespray/inventory/cluster-5
cat >inventory.ini<<EOF
[all]
control.bart.team ansible_host=192.168.218.190
node1.bart.team ansible_host=192.168.218.191
node2.bart.team ansible_host=192.168.218.192
node3.bart.team ansible_host=192.168.218.193
db1.bart.team ansible_host=192.168.218.194
[kube-master]
control.bart.team
[etcd]
control.bart.team
[kube-node]
node1.bart.team
node2.bart.team
node3.bart.team
db1.bart.team
[k8s-cluster:children]
kube-master
kube-node
EOF

cd

echo
echo "[ Install Bind ]"
echo "================"
dnf install bind -y
dnf install bind-utils -y

cat > /etc/named.conf <<EOF
options {
        listen-on port 53 { any; };
        listen-on-v6 port 53 { ::1; };
        directory       "/var/named";
        dump-file       "/var/named/data/cache_dump.db";
        statistics-file "/var/named/data/named_stats.txt";
        memstatistics-file "/var/named/data/named_mem_stats.txt";
        secroots-file   "/var/named/data/named.secroots";
        recursing-file  "/var/named/data/named.recursing";
        allow-query     { any; };
        recursion yes;

        dnssec-enable yes;
        dnssec-validation yes;

        managed-keys-directory "/var/named/dynamic";

        pid-file "/run/named/named.pid";
        session-keyfile "/run/named/session.key";

        /* https://fedoraproject.org/wiki/Changes/CryptoPolicy */
        include "/etc/crypto-policies/back-ends/bind.config";
};

logging {
        channel default_debug {
                file "data/named.run";
                severity dynamic;
        };
};

zone "." IN {
        type hint;
        file "named.ca";
};

zone "bart.team" IN {
        type master;
        file "bart.team";
};

zone "218.168.192.in-addr.arpa" IN {
        type master;
        file "218";
};
include "/etc/named.rfc1912.zones";
include "/etc/named.root.key";
EOF

cat > /var/named/bart.team <<EOF
\$TTL 86400
@ IN SOA master.bart.team. artur.kryukov.biz. (
                                                2021073101 ;Serial
                                                3600 ;Refresh
                                                1800 ;Retry
                                                604800 ;Expire
                                                86400 ;Minimum TTL
)

@ IN NS master

master          IN      A       192.168.218.195
control         IN      A       192.168.218.190
node1           IN      A       192.168.218.191
node2           IN      A       192.168.218.192
node3           IN      A       192.168.218.193
db              IN      A       192.168.218.194

argocd          IN      A       192.168.218.195
keycloak        IN      CNAME   argocd
EOF

cat > /var/named/218 <<EOF
\$TTL 86400
@ IN SOA master.bart.team. artur.kryukov.biz. (
                                            2021012100 ;Serial
                                            3600 ;Refresh
                                            1800 ;Retry
                                            604800 ;Expire
                                            86400 ;Minimum TTL
)
@ IN NS master.bart.team.
195 IN PTR master.bart.team.
190     IN      PTR     control.bart.team.
191     IN      PTR     node1.bart.team.
192     IN      PTR     node2.bart.team.
193     IN      PTR     node3.bart.team.
194     IN      PTR     db.bart.team.
EOF

systemctl start named
systemctl enable named


echo
echo "[ Install nfs server ]"
echo "======================"
dnf install nfs-utils -y

cat > /etc/exports <<EOF
/var/nfs-disk 192.168.218.0/24(rw,sync,no_subtree_check,no_root_squash,no_all_squash,insecure)
EOF

systemctl start nfs-server
systemctl enable nfs-server

