#!/bin/bash

## add ssh known host to compute nodes
for i in `grep eth0 /etc/hosts | awk '{print $1 "\n" $3}' ` ; do
  ssh-keyscan $i
done > /etc/ssh/ssh_known_hosts

cp /etc/ssh/ssh_known_hosts /var/chroots/centos-6/etc/ssh

## install nptd to comupte nodes to sync time with master
yum --tolerant --installroot /var/chroots/centos-6 -y install ntp

sed -i '/centos.pool.ntp.org/c\server 172.16.2.250' /var/chroots/centos-6/etc/ntp.conf

cat >> /var/chroots/centos-6/etc/rc.local << EOF
chkconfig ntpd on
service ntpd start
EOF

## reimage and reboot
~/bin/reim_reboot



