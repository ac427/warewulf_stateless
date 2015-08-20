#!/bin/bash

## format /dev/sda to ext4 on all compute nodes
pdsh -w `grep eth0 /etc/hosts | awk '{print $1}' | paste -d, -s ` "echo y | mkfs.ext4 /dev/sda"

mkdir -p /var/chroots/centos-6/scratch

cat >> /var/chroots/centos-6/etc/fstab << 'EOF'
/dev/sda /scratch ext4 defaults 1 1
EOF

~/bin/reim_reboot
