#!/bin/bash

##partition /dev/sda
pdsh -w `grep eth0 /etc/hosts | awk '{print $1}' | paste -d, -s ` "echo -e 'n\np\n1\n1\n\nw' | fdisk /dev/sda"
## format /dev/sda1 to ext4 on all compute nodes
pdsh -w `grep eth0 /etc/hosts | awk '{print $1}' | paste -d, -s ` "echo y | mkfs.ext4 /dev/sda1"

mkdir -p /var/chroots/centos-6/scratch

## set the sticky bit on scratch
echo "chmod 1777 /scratch" >> /var/chroots/centos-6/etc/rc.local

cat >> /var/chroots/centos-6/etc/fstab << 'EOF'
/dev/sda1 /scratch ext4 defaults 1 1
EOF

~/bin/reim_reboot
