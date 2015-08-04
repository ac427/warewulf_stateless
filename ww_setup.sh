#!/bin/sh
wwinit ALL

echo warewulf making chroot ... 
wwmkchroot centos-6 /var/chroots/centos-6

echo warewulf initiating ...
CHROOTDIR=/var/chroots/centos-6 wwinit ALL

echo warewulf scanning and adding nodes ...
wwnodescan --netdev=eth0 --ipaddr=172.16.0.1 --netmask=255.255.0.0 --vnfs=centos-6 --bootstrap=`uname -r` --groups=newnodes n[01-10]


