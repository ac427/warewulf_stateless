#!/bin/bash

## set passwd first time, you can omit this and go straight to wwinit ALL
## but later slurm will need it
mysqladmin -u root password 'password'
mysql -u root -e "create database warewulf;" -p'password'
## or use: mysqladmin create warewulf -p'password'

## warewulf mysql set up
sed -i '/database user/c\database user = root' /etc/warewulf/database.conf
sed -i '/database password/c\database password = password'  /etc/warewulf/database.conf
sed -i '/database password/c\database password = password' /etc/warewulf/database-root.conf

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
echo "warewulf scanning and adding nodes"
echo "please set compute nodes to PXE boot and bring up them one by one in order"
echo "when all nodes are recorded stop(ctl-c) this script"
echo @
echo @
echo @
sleep 3
wwnodescan --netdev=eth0 --ipaddr=172.16.0.1 --netmask=255.255.0.0 --vnfs=centos-6 --bootstrap=`uname -r` --groups=newnodes n[01-99]

