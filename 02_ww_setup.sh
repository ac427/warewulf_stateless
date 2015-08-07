#!/bin/bash
## first init, vnfs will fail, but will set /etc/fstab correct, wierd?
wwinit ALL

echo warewulf making chroot ... 
wwmkchroot centos-6 /var/chroots/centos-6

#echo warewulf initiating ...
#CHROOTDIR=/var/chroots/centos-6 wwinit ALL
wwvnfs --chroot /var/chroots/centos-6
echo @
echo @
echo @
echo warewulf scanning and adding nodes 
echo please set compute nodes to PXE boot and bring up them one by one in order
echo when all nodes are recorded stop this script
echo @
echo @
echo @
sleep 3
wwnodescan --netdev=eth0 --ipaddr=172.16.0.1 --netmask=255.255.0.0 --vnfs=centos-6 --bootstrap=`uname -r` --groups=newnodes n[01-10]


