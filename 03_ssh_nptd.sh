#!/bin/bash

## add ssh known host to compute nodes
for i in `grep eth0 /etc/hosts | awk '{print $1 "\n" $3}' ` ; do
  ssh-keyscan $i
done > /etc/ssh/ssh_known_hosts

cp /etc/ssh/ssh_known_hosts /var/chroots/centos-6/etc/ssh

## install nptd to comupte nodes to sync time with master
yum --tolerant --installroot /var/chroots/centos-6 -y install ntp
cat > /var/chroots/centos-6/etc/ntp.conf << EOF
driftfile /var/lib/ntp/drift
restrict default ignore
restrict 127.0.0.1
server 172.16.2.250 (this is the master’s ip, compute node sync to master node time)
restrict 172.16.2.250 nomodify
includefile /etc/ntp/crypto/pw
keys /etc/ntp/keys
EOF
cat >> /var/chroots/centos-6/etc/rc.local << EOF
chkconfig ntpd on
service ntpd start
EOF

## reimage and reboot
echo rebuilding the image ...
wwvnfs -y --chroot /var/chroots/centos-6
echo rebooting the computing nodes
sleep 3
pdsh -w `grep eth0 /etc/hosts | awk '{print $1}' | paste -d, -s ` reboot



