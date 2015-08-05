#!/bin/bash

for i in `grep eth0 /etc/hosts | awk '{print $1 "\n" $3}' ` ; do
  ssh-keyscan $i
done > /etc/ssh/ssh_known_hosts

cp /etc/ssh/ssh_known_hosts /var/chroots/centos-6/etc/

## rebuild image and reboot compute nodes or sync file to take effect on compute nodes
## wwvnfs -y --chroot /var/chroots/centos-6
## pdsh -w `grep eth0 /etc/hosts | awk '{print $1}' | paste -d, -s ` reboot

wwsh -y file import /etc/ssh/ssh_known_hosts
wwsh -y provision set --fileadd ssh_known_hosts
wwsh file sync



