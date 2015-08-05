#!/bin/bash
## usage: cmd n01 n02 n03 ... or cmd n{01..09}
for i in `grep eth0 /etc/hosts | awk '{print $1 "\n" $3}' ` ; do
  ssh-keyscan $i
done > /etc/ssh/ssh_known_hosts

cp /etc/ssh/ssh_known_hosts /var/chroots/centos-6/etc/

wwsh -y file import /etc/ssh/ssh_known_hosts
wwsh -y provision set --fileadd ssh_known_hosts
wwsh file sync


## rebuild image or sync file to take effect on compute nodes
