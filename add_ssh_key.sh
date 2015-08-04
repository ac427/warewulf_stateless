#!/bin/sh
## usage: cmd 01 03
for i in n{$1..$2}; do
  ssh-keyscan $i
done > /etc/ssh/ssh_known_hosts

cp /etc/ssh/ssh_known_hosts /var/chroots/centos-6/etc/
